class Locations {
  String? id;
  String? name;
  int? votes;

  Locations({
    this.id,
    this.name,
    this.votes,
  });

  factory Locations.fromMap(Map<String, dynamic> obj) => Locations(
        id: obj.containsKey('id') ? obj['id'] : 'no-id',
        name: obj.containsKey('name') ? obj['name'] : 'no-name',
        votes: obj.containsKey('votes') ? obj['votes'] : 'no-votes',
      );
}
