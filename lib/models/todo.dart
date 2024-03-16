class Todo {
  int id;
  String content;
  Todo(this.id, this.content);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'content': content,
    };
  }

  @override
  String toString() {
    return 'Todo{id:$id, name:$content}';
  }
}
