class TaskToDo {
  String? title;
  String? content;
  String? added;
  String? due;

  TaskToDo(this.added, this.content, this.due, this.title);

  Map<String, dynamic> toJson() {
    return {'title': title, 'content': content, 'added': added, 'due': due};
  }

  TaskToDo.fromJson(Map<String , dynamic> json){
    title = json['title'];
    content = json['content'];
    due = json['due'];
    added = json['added'];

  }

  
}
