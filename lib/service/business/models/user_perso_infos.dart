class UserPersoInfos {
  final String name;
  final String sexe;
  final String email;
  final String phoneNumber;
  final String dateOfBirth;
  final String placeOfBirth;
  final String nationality;
  final String address;
  final String maritalStatus;
  final String profil;

  const UserPersoInfos({
    required this.name,
    required this.sexe,
    required this.email,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.placeOfBirth,
    required this.nationality,
    this.address = 'N/A',
    this.maritalStatus = 'N/A',
    this.profil = 'N/A',
  });
}
