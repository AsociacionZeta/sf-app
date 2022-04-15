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

    private void count(SObjectType sObjectType) {
        if (!limitedTriggers.containsKey(sObjectType)) {
            limitedTriggers.put(sObjectType, new TriggerLimit(-1));
        }
        limitedTriggers.get(sObjectType).increment();
    }

    /**
     * PUBLIC STATIC METHODS FOR TRIGGER HANDLING
     */
    public static void bypass(SObjectType sObjectType) {
        bypassedTriggers.add(sObjectType);
    }

    public static boolean isBypassed(SObjectType sObjectType) {
        return bypassedTriggers.contains(sObjectType);
    }

    public static void removeBypass(SObjectType sObjectType) {
        bypassedTriggers.remove(sObjectType);
    }

    public static void removeAllBypasses() {
        bypassedTriggers.clear();
    }

    public static void limitTrigger(SObjectType sObjectType, Integer triggerLimit) {
        if (!limitedTriggers.containsKey(sObjectType)) {
            limitedTriggers.put(sObjectType, new TriggerLimit(triggerLimit));
        } else {
            limitedTriggers.get(sObjectType).setLimit(triggerLimit);
        }
    }

    public static void clearLimit(SObjectType sObjectType) {
        if (limitedTriggers.containsKey(sObjectType)) {
            limitedTriggers.get(sObjectType).clearLimit();
        }
    }

    /**
     * METHODS TO INHERIT
     */
    @TestVisible
    protected virtual void bulkInsert(List<SObject> newList) {
    }

    @TestVisible
    protected virtual void bulkUpdate(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    }

    @TestVisible
    protected virtual void bulkDelete(Map<Id, SObject> oldMap) {
    }

    @TestVisible
    protected virtual void bulkUndelete(Map<Id, SObject> newMap) {
    }

    @TestVisible
    protected virtual void beforeInsert(SObject newRecord) {
    }

    @TestVisible
    protected virtual void beforeInsertBulk(List<SObject> newList) {
    }

    @TestVisible
    protected virtual void afterInsert(SObject newRecord) {
    }

    @TestVisible
    protected virtual void afterInsertBulk(Map<Id, SObject> newMap) {
    }

    @TestVisible
    protected virtual void beforeUpdate(SObject newRecord, SObject oldRecord) {
    }

    @TestVisible
    protected virtual void beforeUpdateBulk(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    }

    @TestVisible
    protected virtual void afterUpdate(SObject newRecord, SObject oldRecord) {
    }

    @TestVisible
    protected virtual void afterUpdateBulk(Map<Id, SObject> newMap, Map<Id, SObject> oldMap) {
    }

    @TestVisible
    protected virtual void beforeDelete(SObject oldRecord) {
    }

    @TestVisible
    protected virtual void beforeDeleteBulk(Map<Id, SObject> oldMap) {
    }

    @TestVisible
    protected virtual void afterDelete(SObject oldRecord) {
    }

    @TestVisible
    protected virtual void afterDeleteBulk(Map<Id, SObject> oldMap) {
    }

    @TestVisible
    protected virtual void afterUndelete(SObject newRecord) {
    }

    @TestVisible
    protected virtual void afterUndeleteBulk(Map<Id, SObject> newMap) {
    }

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