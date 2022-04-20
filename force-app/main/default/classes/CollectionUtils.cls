public with sharing class CollectionUtils {
    
    public static Set<Id> mergeSet(Set<Id> source, Set<Id> target) {
		List<Id> result = new List<Id>();
		result.addAll(source);
		result.addAll(target);
		return new Set<Id>(result);
	}

	public static Set<String> mergeSet(Set<String> source, Set<String> target) {
		List<String> result = new List<String>();
		result.addAll(source);
		result.addAll(target);
		return new Set<String>(result);
	}

}
