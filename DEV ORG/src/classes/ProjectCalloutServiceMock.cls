@isTest
global class ProjectCalloutServiceMock implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        String response = 'SUCCESS';

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody(response);

        return res;
    }
}