
public abstract class RestServiceCallout {
    protected CalloutService.CalloutBuilder calloutBuilder;
    protected final Map<String, Object> inputParameters = new Map<String, Object>();


    
    protected abstract Object build();

}