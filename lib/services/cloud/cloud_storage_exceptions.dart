class CloudStorageExceptions implements Exception {
  const CloudStorageExceptions();
}

class CouldNotCreateUserException extends CloudStorageExceptions {}

class CouldNotCreateAdminException extends CloudStorageExceptions {}

class CouldNotUpdateInformationException extends CloudStorageExceptions {}

class CouldNotDeleteUserException extends CloudStorageExceptions {}

//other firestore exceptions for booking and flight and ticket