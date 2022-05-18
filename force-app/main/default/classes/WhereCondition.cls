public class WhereCondition {
    @AuraEnabled
		public String field { get; set; }

		@AuraEnabled
		public String operator { get; set; }

		@AuraEnabled
		public Object value { get; set; }
}
