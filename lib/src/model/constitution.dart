import 'package:firebase/firestore.dart';

class Constitution {
  String title;
  List<Schedule> schedules;
  List<Chapter> chapters;

  Constitution({this.title, this.schedules, this.chapters});

  Constitution.fromJson(Map<String, dynamic> json, String id) {
    title = json['title'];
    if (json['schedules'] != null) {
      schedules = new List<Schedule>();
      json['schedules'].forEach((v) {
        schedules.add(new Schedule.fromJson(v));
      });
    }
    if (json['chapters'] != null) {
      chapters = new List<Chapter>();
      json['chapters'].forEach((v) {
        chapters.add(new Chapter.fromJson(v, id));
      });
    }
  }

  Constitution.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    print("fromDocumentSnapshot $data");

    title = data['title'];
    if (data['schedules'] != null) {
      schedules = new List<Schedule>();
      data['schedules'].forEach((v) {
        schedules.add(new Schedule.fromJson(v));
      });
    }
    if (data['chapters'] != null) {
      chapters = new List<Chapter>();
      data['chapters'].forEach((v) {
        chapters.add(new Chapter.fromJson(v, snapshot.id));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.schedules != null) {
      data['schedules'] = this.schedules.map((v) => v.toJson()).toList();
    }
    if (this.chapters != null) {
      data['chapters'] = this.chapters.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Schedule {
  String title;
  List<Items> items;

  Schedule({this.title, this.items});

  Schedule.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String header;
  String content;

  Items({this.header, this.content});

  Items.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['header'] = this.header;
    data['content'] = this.content;
    return data;
  }
}

class Chapter {
  String id;
  String title;
  List<Part> parts;

  Chapter({this.title, this.parts});

  Chapter.fromJson(Map<String, dynamic> json, String id) {
    id = id;
    title = json['title'];
    if (json['parts'] != null) {
      parts = new List<Part>();
      json['parts'].forEach((v) {
        parts.add(new Part.fromJson(v));
      });
    }
  }

  Chapter.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    id = snapshot.id;
    title = data['title'];

    if (data['parts'] != null) {
      parts = new List<Part>();
      data['parts'].forEach((v) {
        parts.add(new Part.fromJson(v));
      });
    }
  }


  List<Section> getAllSections() {
    List<Section> _sections = [];
    for(Part part in parts) {
      _sections.addAll(part.sections);
    }
    return _sections;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;

    if (this.parts != null) {
      data['parts'] = this.parts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Section {
  int id;
  String title;
  String content;

  Section({this.id, this.title, this.content});

  Section.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    return data;
  }
}

class Part {
  String name;
  List<Section> sections;

  Part({this.name, this.sections});

  Part.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['sections'] != null) {
      sections = new List<Section>();
      json['sections'].forEach((v) {
        sections.add(new Section.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.sections != null) {
      data['sections'] = this.sections.map((v) => v.toJson()).toList();
    }
    return data;
  }
}