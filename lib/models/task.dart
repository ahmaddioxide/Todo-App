class Task {
  final int? id;
  final String? title;
  final String? description;
  final String? date;
  final String? time;
  // TODO: Avoid using the comments in your code. Write your code as it will be easier to undertandable by other developer or we write documentation
  final int? status; // 0 - Incomplete, 1 - Complete

  Task(
      {this.id,
      this.title,
      this.description,
      this.date,
      this.time,
      this.status}); // TODO: Always use trailing commas to veritically format your code

  Task.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        title = map['title'],
        description = map['description'],
        date = map['date'],
        time = map['time'],
        status = map['status'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'status': status,
    };
  }
}
