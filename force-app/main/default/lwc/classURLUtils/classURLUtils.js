
/**
 * Class to handle all about URLs like get query parameters or check things about URL
 */
export default class URLUtils {

    /**
     * Method to get query parameters from active or any URL
     * @param {String} [url] URL to check, if null or not pass url param, will be check the active page URL
     *  
     * @returns {Object} Return an object with query parameters like { 'paramName1': paramValue1, 'paramName2': paramValue2, ...}
     */
    static getURLParameters(url) {
        const params = {};
        const urlParams = new URL(url || window.location.href).searchParams;
        urlParams.forEach((value, key) => {
            params[key] = value;
        });
        return params;
    }

    static getContextOfRefData(url) {
        const params = this.getURLParameters(url);
        let context = params.inContextOfRef;
        if(context){
            if (context.startsWith("1\.")) {
                context = context.substring(2);
            }
            return JSON.parse(window.atob(context));
        }
        return undefined;        
    }

    /**
     * Method to check if the execution context are the linghtning app builder or communiity builder
     * @returns {Boolean} True if the execution contexts is the app or community builder, false in otherwise
     */
    static isOnBuilderContext(){
        var urlToCheck = window.location.hostname;
        urlToCheck = urlToCheck.toLowerCase();
        return urlToCheck.indexOf('sitepreview') >= 0 || urlToCheck.indexOf('livepreview') >= 0;
    }

}