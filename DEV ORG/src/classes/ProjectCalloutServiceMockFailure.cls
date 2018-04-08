@isTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        String response = 'ERROR FROM EXTERNAL SITE';

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(500);
        res.setBody(response);

        return res;
    }
}