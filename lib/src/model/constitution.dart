class Constitution {
  String title;
  List<Schedule> schedules;
  List<Chapter> chapters;

  Constitution({this.title, this.schedules, this.chapters});

  Constitution.fromJson(Map<String, dynamic> json) {
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
        chapters.add(new Chapter.fromJson(v));
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
  int number;
  String title;
  List<Section> sections;
  List<Part> parts;

  Chapter({this.title, this.sections, this.parts});

  Chapter.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    title = json['title'];
    if (json['sections'] != null) {
      sections = new List<Section>();
      json['sections'].forEach((v) {
        sections.add(new Section.fromJson(v));
      });
    }
    if (json['parts'] != null) {
      parts = new List<Part>();
      json['parts'].forEach((v) {
        parts.add(new Part.fromJson(v));
      });
    }
  }

  String chapterTitle(int index) {
    final title = "Chapter $index -  ${this.title}";
    return title;
  }
  List<Section> getAllSections() {
   if(sections != null && sections.isNotEmpty) {
     return sections;
   } else {
     List<Section> _sections = [];
     for(Part part in parts) {
       _sections.addAll(part.sections);
     }
     return _sections;
   }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['number'] = this.number;
    if (this.sections != null) {
      data['sections'] = this.sections.map((v) => v.toJson()).toList();
    }
    if (this.parts != null) {
      data['parts'] = this.parts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Section {
  int number;
  String title;
  String content;

  Section({this.number, this.title, this.content});

  Section.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['title'] = this.title;
    data['content'] = this.content;
    return data;
  }
}

class Part {
  String header;
  List<Section> sections;

  Part({this.header, this.sections});

  Part.fromJson(Map<String, dynamic> json) {
    header = json['header'];
    if (json['sections'] != null) {
      sections = new List<Section>();
      json['sections'].forEach((v) {
        sections.add(new Section.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['header'] = this.header;
    if (this.sections != null) {
      data['sections'] = this.sections.map((v) => v.toJson()).toList();
    }
    return data;
  }
}