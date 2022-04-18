public virtual class TriggerHandler {
    private static Set<SObjectType> bypassedTriggers = new Set<SObjectType>();
    private static Map<SObjectType, TriggerLimit> limitedTriggers = new Map<SObjectType, TriggerLimit>();
    @TestVisible
    private TriggerOperation operationType { get; set; }

    @TestVisible
    private Map<Id, SObject> newMap { get; set; }

    @TestVisible
    private Map<Id, SObject> oldMap { get; set; }

    @TestVisible
    private List<SObject> newList { get; set; }

    /**
     * Main triggers method. The only one method to call from triggers to run any trigger
     *
     * @param sObjectType (SObjectType): Trigger SObject Type 
     */
    public void run(SObjectType sObjectType) {
        if (!shouldBeRun(sObjectType)) {
            return;
        }
        count(sObjectType);
        if (!Test.isRunningTest()) {
            this.operationType = Trigger.operationType;
            this.newMap = Trigger.newMap;
            this.oldMap = Trigger.oldMap;
            this.newList = Trigger.new;
        }
        if (this.operationType == TriggerOperation.BEFORE_INSERT) {
            this.bulkInsert(this.newList);
            for (SObject newRecord : this.newList) {
                this.beforeInsert(newRecord);
            }
            this.beforeInsertBulk(this.newList);
        } else if (this.operationType == TriggerOperation.AFTER_INSERT) {
            for (SObject newRecord : this.newList) {
                this.afterInsert(newRecord);
            }
            this.afterInsertBulk(this.newMap);
            this.onFinally();
        } else if (this.operationType == TriggerOperation.BEFORE_UPDATE) {
            this.bulkUpdate(this.newMap, this.oldMap);
            for (SObject newRecord : this.newMap.values()) {
                SObject oldRecord = this.oldMap.get((Id) newRecord.get('Id'));
                this.beforeUpdate(newRecord, oldRecord);
            }
            this.beforeUpdateBulk(this.newMap, this.oldMap);
        } else if (this.operationType == TriggerOperation.AFTER_UPDATE) {
            for (SObject newRecord : this.newMap.values()) {
                SObject oldRecord = this.oldMap.get((Id) newRecord.get('Id'));
                this.afterUpdate(newRecord, oldRecord);
            }
            this.afterUpdateBulk(this.newMap, this.oldMap);
            this.onFinally();
        } else if (this.operationType == TriggerOperation.BEFORE_DELETE) {
            this.bulkDelete(this.oldMap);
            for (SObject oldRecord : this.oldMap.values()) {
                this.beforeDelete(oldRecord);
            }
            this.beforeDeleteBulk(this.oldMap);
        } else if (this.operationType == TriggerOperation.AFTER_DELETE) {
            for (SObject oldRecord : this.oldMap.values()) {
                this.afterDelete(oldRecord);
            }
            this.afterDeleteBulk(this.oldMap);
            this.onFinally();
        } else if (this.operationType == TriggerOperation.AFTER_UNDELETE) {
            this.bulkUndelete(newMap);
            for (SObject newRecord : this.newList) {
                this.afterUndelete(newRecord);
            }
            this.afterUndeleteBulk(this.newMap);
            this.onFinally();
        }
    }

    /**
     * PRIVATE METHODS FOR TRIGGER HANDLING
     */

    /**
     * Method to decide if the trigger should be run or not because limits, bypasses or other reasons
     *
     * @param sObjectType (SObjectType): Trigger SObject Type
     *
     * @return boolean: Return true if the trigger should be run, false in otherwise
     */
    private boolean shouldBeRun(SObjectType sObjectType) {
        if (TriggerHandler.isBypassed(sObjectType)) {
            return false;
        }
        if (limitedTriggers.containsKey(sObjectType) && limitedTriggers.get(sObjectType).isLimitExceeded()) {
            return false;
        }
        if (!Trigger.isExecuting && !Test.isRunningTest()) {
            return false;
        }
        return true;
    }

    /**
     * Method to count trigger executions
     *
     * @param sObjectType (SObjectType): Trigger SObject Type
     */
    private void count(SObjectType sObjectType) {
        if (!limitedTriggers.containsKey(sObjectType)) {
            limitedTriggers.put(sObjectType, new TriggerLimit(-1));
        }
        limitedTriggers.get(sObjectType).increment();
    }

    /**
     * PUBLIC STATIC METHODS FOR TRIGGER HANDLING
     */

    /**
     * Method to bypass any trigger at any moment
     *
     * @param sObjectType (SObjectType): Trigger SObject Type to bypass
     */
    public static void bypass(SObjectType sObjectType) {
        bypassedTriggers.add(sObjectType);
    }

    /**
     * Method to check if any trigger is bypassed
     *
     * @param sObjectType (SObjectType): Trigger SObject Type to check bypass
     *
     * @return boolean: Return true if trigger is bypassed, false in otherwise
     */
    public static boolean isBypassed(SObjectType sObjectType) {
        return bypassedTriggers.contains(sObjectType);
    }

    /**
     * Method to remove the bypass from any object
     *
     * @param sObjectType (SObjectType): Trigger SObject Type to remove bypass
     */
    public static void removeBypass(SObjectType sObjectType) {
        bypassedTriggers.remove(sObjectType);
    }

    /**
     * Method to remove all trigger's bypasses
     */
    public static void removeAllBypasses() {
        bypassedTriggers.clear();
    }

    /**
     * Method to limit any trigger execution
     *
     * @param sObjectType (SObjectType): Trigger SObject Type to limit
     * @param triggerLimit (Integer): Number of executions
     */
    public static void limitTrigger(SObjectType sObjectType, Integer triggerLimit) {
        if (!limitedTriggers.containsKey(sObjectType)) {
            limitedTriggers.put(sObjectType, new TriggerLimit(triggerLimit));
        } else {
            limitedTriggers.get(sObjectType).setLimit(triggerLimit);
        }
    }

    /**
     * Method to clear any trigger limit
     *
     * @param sObjectType (SObjectType): Trigger SObject Type to clear the limit
     */
    public static void clearLimit(SObjectType sObjectType) {
        if (limitedTriggers.containsKey(sObjectType)) {
            limitedTriggers.get(sObjectType).clearLimit();
        }
    }

    /**
     * METHODS TO INHERIT
     */

    /**
     * Method to make queries and create data structures on trigger insert operations.
     * This method will be execute always before the beforeInsert method
     *
     * @param newList (List<SObject>): New Records from trigger
     */
    @TestVisible
    protected virtual void bulkInsert(List<SObject> newList) {
    }

    /**
     * Method to make queries and create data structures on trigger update operations
     * This method will be execute always before the beforeUpdate method
     * 
     * @param newMap (Map<Id, SObject>): New Records Map from trigger
     * @param oldMap (Map<Id, SObject>): Old Records Map from trigger
     */
    @TestVisible
    protected virtual void bulkUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    }

    /**
     * Method to make queries and create data structures on trigger delete operations
     * This method will be execute always before the beforeDelete method
     * 
     * @param oldMap (Map<Id, SObject>): Old Records Map from trigger
     */
    @TestVisible
    protected virtual void bulkDelete(Map<Id, SObject> oldMap) {
    }

    /**
     * Method to make queries and create data structures on trigger undelete operations
     * This method will be execute always before the afterUndelete method
     * 
     * @param newMap (Map<Id, SObject>): New Records Map from trigger
     */
    @TestVisible
    protected virtual void bulkUndelete(Map<Id, SObject> newMap) {
    }

    /**
     * Method to handle before insert logic.
     * This method will be run in loop with all trigger records. 
     * DML and Queries ARE NOT ALLOWED in this method because run in loop with every trigger record.
     *
     * @param newRecord (SObject): New record from trigger
     */
    @TestVisible
    protected virtual void beforeInsert(SObject newRecord) {
    }

    /**
     * Method to handle before insert logic in bulk cases.
     * This methos will be execute after the loop on beforeInsert method
     * This method Allow DML and Queries because receive all trigger elements and don't run in loop.
     *
     * @param newList (List<SObject>): New records from trigger
     */
    @TestVisible
    protected virtual void beforeInsertBulk(List<SObject> newList) {
    }

    /**
     * Method to handle after insert logic.
     * This method will be run in loop with all trigger records.
     * DML and Queries ARE NOT ALLOWED in this method because run in loop with every trigger record.
     *
     * @param newRecord (SObject): New records from trigger
     */
    @TestVisible
    protected virtual void afterInsert(SObject newRecord) {
    }

    /**
     * Method to handle after insert logic in bulk cases
     * This methos will be execute after the loop on afterInsert method
     * This method Allow DML and Queries because receive all trigger elements and don't run in loop.
     * 
     * @param newMap (Map<Id, SObject>): New records map from trigger
     */
    @TestVisible
    protected virtual void afterInsertBulk(Map<Id, SObject> newMap) {
    }

    /**
     * Method to handle before update logic
     * This method will be run in loop with all trigger records.
     * DML and Queries ARE NOT ALLOWED in this method because run in loop with every trigger record.
     *
     * @param newRecord (SObject): New record from trigger
     * @param oldRecord (SObject): Old record from trigger
     */
    @TestVisible
    protected virtual void beforeUpdate(SObject newRecord, SObject oldRecord) {
    }

    /**
     * Method to handle before update logic in bulk cases
     * This methos will be execute after the loop on beforeUpdate method
     * This method Allow DML and Queries because receive all trigger elements and don't run in loop.
     *
     * @param newMap (Map<Id, SObject>): New records map from trigger
     * @param oldMap (Map<Id, SObject>): Old records map from trigger
     */
    @TestVisible
    protected virtual void beforeUpdateBulk(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    }

    /**
     * Method to handle after update logic
     * This method will be run in loop with all trigger records.
     * DML and Queries ARE NOT ALLOWED in this method because run in loop with every trigger record.
     *
     * @param newRecord (SObject): New record from trigger
     * @param oldRecord (SObject): Old record from trigger
     */
    @TestVisible
    protected virtual void afterUpdate(SObject newRecord, SObject oldRecord) {
    }

    /**
     * Method to handle after update logic in bulk cases
     * This methos will be execute after the loop on afterUpdate method
     * This method Allow DML and Queries because receive all trigger elements and don't run in loop.
     *
     * @param newMap (Map<Id, SObject>): New records map from trigger
     * @param oldMap (Map<Id, SObject>): Old records map from trigger
     *
     *
     * @throws Class name here Write the class description
     */
    @TestVisible
    protected virtual void afterUpdateBulk(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    }

    /**
     * Method to handle before delete logic
     * This method will be run in loop with all trigger records.
     * DML and Queries ARE NOT ALLOWED in this method because run in loop with every trigger record.
     *
     * @param oldRecord (SObject): Old record from trigger
     */
    @TestVisible
    protected virtual void beforeDelete(SObject oldRecord) {
    }

    /**
     * Method to handle before delete logic in bulk cases
     * This methos will be execute after the loop on beforeDelete method
     * This method Allow DML and Queries because receive all trigger elements and don't run in loop.
     *
     * @param oldMap (Map<Id, SObject>): Old records map from trigger
     */
    @TestVisible
    protected virtual void beforeDeleteBulk(Map<Id, SObject> oldMap) {
    }

    /**
     * Method to handle after delete logic
     * This method will be run in loop with all trigger records.
     * DML and Queries ARE NOT ALLOWED in this method because run in loop with every trigger record.
     *
     * @param oldRecord (SObject): Old record from trigger
     */
    @TestVisible
    protected virtual void afterDelete(SObject oldRecord) {
    }

    /**
     * Method to handle after delete logic in bulk cases
     * This methos will be execute after the loop on afterDelete method
     * This method Allow DML and Queries because receive all trigger elements and don't run in loop.
     *
     * @param oldMap (Map<Id, SObject>): Old records map from trigger
     */
    @TestVisible
    protected virtual void afterDeleteBulk(Map<Id, SObject> oldMap) {
    }

    /**
     * Method to handle after undelete logic
     * This method will be run in loop with all trigger records.
     * DML and Queries ARE NOT ALLOWED in this method because run in loop with every trigger record.
     *
     * @param oldRecord (SObject): Old record from trigger
     */
    @TestVisible
    protected virtual void afterUndelete(SObject newRecord) {
    }

    /**
     * Method to handle after undelete logic in bulk cases
     * This methos will be execute after the loop on afterUndelete method
     * This method Allow DML and Queries because receive all trigger elements and don't run in loop.
     *
     * @param oldMap (Map<Id, SObject>): Old records map from trigger
     */
    @TestVisible
    protected virtual void afterUndeleteBulk(Map<Id, SObject> newMap) {
    }

    /**
     * This method will be execute always when finished any trigger operation, that is,
     * is the last method to execute on insert, update... specially desgined to make any DML operation.
     */
    @TestVisible
    protected virtual void onFinally() {
    }

    public class TriggerLimit {
        private Integer triggerLimit = -1;
        private Integer count = 0;
        public TriggerLimit(Integer triggerLimit) {
            this.triggerLimit = triggerLimit;
        }

        public void clearLimit() {
            this.triggerLimit = -1;
        }

        public Integer getLimit() {
            return this.triggerLimit;
        }

        public Integer getCount() {
            return this.count;
        }

        public void setLimit(Integer triggerLimit) {
            this.triggerLimit = triggerLimit;
        }

        public void increment() {
            this.count++;
        }

        public boolean isLimitExceeded() {
            return this.triggerLimit > -1 && this.triggerLimit < this.count;
        }

    }

}