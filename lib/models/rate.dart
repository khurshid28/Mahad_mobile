class Rate {
  final num avg;
  final int try_count;
  final int id;
  final int index;
  final String name;
  final int specialTestCount;
  final int bookCount;
  final int regularTestCount;
 
  Rate({
    required this.avg,
    required this.try_count,
    required this.id,
    required this.index,
    required this.name,
    this.specialTestCount = 0,
    this.bookCount = 0,
    this.regularTestCount = 0,
  });
}
