import 'package:googleapis_auth/auth_io.dart';

/// Simple holder for auth data we need to call FCM HTTP v1
class ServerAuth {
  final String accessToken;
  final String projectId;
  const ServerAuth(this.accessToken, this.projectId);
}

class GetServerKey {
  // Keep your existing service account JSON here
  static const Map<String, dynamic> _credsJson = {
    "type": "service_account",
    "project_id": "red-balloon-app",
    "private_key_id": "ca284a35c85ceb5a7db812cfcb90a888d23b4180",
    "private_key":
        "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCXyNZYTwr9/szb\n+KgSUj7JAcS2Cdxdt5PTv/LKQ5KuGrCjhezlUGvtwPWEm+Nodat6kQrpm/2K1jAz\nZkkKEyVJgsAZ7o5+UixP9nL3dg/QrFu+wy0Jx+amFAGU5Xvbw+zC+aIbuNVfj/Ea\n9nVgDj2IN2ojYkcykLpTzjhEVSx5RtaqY8or5URiQORNb1xBeh8WgdCTDU7Fc91F\nkKQWaUyERGbZ7x0+aIU9HmmqccqXTpgTID6HXdUPkrigfSumcbGiJD6Kh94Vk6/o\nYHzusps+clSkR+PE0aRxikq0hGsZ8ITEkcqLR9VcNzY+hgM6AnDi5rqUchWOgQHK\nwDyHLDClAgMBAAECggEAE3gCgljqfIeFEwazLDJvdOHsr5Ar5hDI0zAmPhUVHeQ0\n2ayxJP1qnULoWxDnG5F9pB7cQE2uuPMImLcwfCyA1mEr2cepxastnY4WKLFJ4wa7\nTTMvYOH1WZfBrNhontjj0rh+t2vptom52oRYAYZMvzRNwWnMNGta8v/wY1dsznCk\nczySn97ya/2RCvu5WbQzlUUWZ1UglSG1e8irROpIo31WlJ4n+QWwoeb5hMVmviOd\nQUbKyv7+QxMyvGsjKVXKXv5G5fV4RJ0+tfnC7hOOFxxCBO0G8yW6an6qKQNOaK0D\n8CR6l2HYYBChTpTP1ndiuK0+O5RTHm93Y95nkoJCqwKBgQDULasc7ou1CD+1/Ax0\n4VtDtssL+21toHJMYGhIqESCNb1mw04mzwRgWZPn87Yv5+Z4SJiQ8Vvn91bYRaDt\nV9VFXysC0ibk2IaeVzEVn343dLmvBbVdDNaUe8gt0amzNY+3GOcqYFaGbne53GWg\n8tSXzdKXPhPbWfcvPpPuS8vD+wKBgQC3IgOSbo0Ig5mOQESrEFha7PGHRVZbOeDg\nGHuhrK3WALqJR3gxPbnnB3p3CtqUl9rkhraDkjpEne1sRDTfK44X2aT8bhNRzkpB\ndY8vCSAxntJPfYnoEbZsLCgP/mK6P2wT9+ucsfYsT31JyGwhT8FUhmnnY6tpYWTu\n1YMcaDMb3wKBgC1G5YnR+awS642JEJtsb44+loujBpHrOBjGRdqjVaM3log0SxwK\n9xMcamyH3CvS36JxU2Uyq/sPE9Ao45NiN9eK3GHIuJYDAo8NaiMEGun4lZscq7wE\nflHHLEtiv0THvDhFLyci0bP0JMZbmrBCwUz3leXCUHhxdUb2opiqQfw7AoGAa/18\nyb6zH9Aqnr27QHy0/Xk3vCLhF4570undDat8HvPzC7y/XZoeo+O/Da+y0WjyxUvD\nGLcD8S6HsQ5Pd0KB2gKXzdtDPTw+gXdHZd8lwtz6+7D1v4miXwty3GuP4HBB1Uye\n/ZnbpqmBIh8z1DjpsmRI0w/tJokuMcBqPjgb21UCgYEAzXizyQ8wiCfk3zckkHCc\ndoaEwLv6DUnes71fwbbhzUywF0oP1OaTYcRKL9/5Tb9ajv2rQ2U2yjGCjvNE7Wyj\ngnwuBbPv27gvAGJb/rogkgf/YbU25emRqr1W5ApBPweMLQElE6U7P1KdFPo7dPxw\nZIbGwTdu5pXb/NmgL6WfL94=\n-----END PRIVATE KEY-----\n",
    "client_email":
        "firebase-adminsdk-fbsvc@red-balloon-app.iam.gserviceaccount.com",
    "client_id": "105144857192584193562",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40red-balloon-app.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com",
  };

  /// New: returns BOTH accessToken and projectId so your caller can build the correct FCM URL.
  Future<ServerAuth> getAccess() async {
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final credentials = ServiceAccountCredentials.fromJson(_credsJson);
    final client = await clientViaServiceAccount(credentials, scopes);
    return ServerAuth(
      client.credentials.accessToken.data,
      _credsJson['project_id'] as String,
    );
  }

  /// Backwards-compat helper: if old code expects just the token.
  Future<String> getServerKeyToken() async {
    final auth = await getAccess();
    return auth.accessToken;
  }
}
