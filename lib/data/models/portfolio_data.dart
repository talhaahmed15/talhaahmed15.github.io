class PortfolioData {
  PortfolioData({
    required this.owner,
    required this.startup,
    required this.socials,
    required this.about,
    required this.projects,
    required this.lastUpdated,
  });

  final OwnerProfile owner;
  final StartupInfo startup;
  final List<SocialLink> socials;
  final AboutInfo about;
  final List<PortfolioProject> projects;
  final String lastUpdated;

  factory PortfolioData.fromMap(Map<String, dynamic> map) {
    return PortfolioData(
      owner: OwnerProfile.fromMap(map['owner'] as Map<String, dynamic>? ?? {}),
      startup: StartupInfo.fromMap(
        map['startup'] as Map<String, dynamic>? ?? {},
      ),
      socials: ((map['socials'] as List<dynamic>? ?? [])
          .map((item) => SocialLink.fromMap(item as Map<String, dynamic>))
          .toList()),
      about: AboutInfo.fromMap(map['about'] as Map<String, dynamic>? ?? {}),
      projects: ((map['projects'] as List<dynamic>? ?? [])
          .map((item) => PortfolioProject.fromMap(item as Map<String, dynamic>))
          .toList()),
      lastUpdated: _string(map['lastUpdated'], fallback: 'February 2026'),
    );
  }
}

class OwnerProfile {
  OwnerProfile({
    required this.name,
    required this.role,
    required this.bio,
    required this.email,
    required this.resumeUrl,
  });

  final String name;
  final String role;
  final String bio;
  final String email;
  final String resumeUrl;

  factory OwnerProfile.fromMap(Map<String, dynamic> map) {
    return OwnerProfile(
      name: _string(map['name'], fallback: 'Your Name'),
      role: _string(map['role'], fallback: 'Developer'),
      bio: _string(
        map['bio'],
        fallback: 'I build practical digital products with clean engineering.',
      ),
      email: _string(map['email'], fallback: 'hello@example.com'),
      resumeUrl: _string(
        map['resumeUrl'],
        fallback: 'https://example.com/resume',
      ),
    );
  }
}

class StartupInfo {
  StartupInfo({
    required this.name,
    required this.tagline,
    required this.image,
    required this.url,
  });

  final String name;
  final String tagline;
  final String image;
  final String url;

  factory StartupInfo.fromMap(Map<String, dynamic> map) {
    return StartupInfo(
      name: _string(map['name'], fallback: 'Your Startup'),
      tagline: _string(
        map['tagline'],
        fallback: 'Building the next big thing.',
      ),
      image: _string(map['image'], fallback: 'assets/images/startup.jpg'),
      url: _string(map['url'], fallback: ''),
    );
  }
}

class SocialLink {
  SocialLink({required this.label, required this.url});

  final String label;
  final String url;

  factory SocialLink.fromMap(Map<String, dynamic> map) {
    return SocialLink(
      label: _string(map['label'], fallback: 'Link'),
      url: _string(map['url'], fallback: 'https://example.com'),
    );
  }
}

class AboutInfo {
  AboutInfo({required this.text, required this.skills});

  final String text;
  final List<String> skills;

  factory AboutInfo.fromMap(Map<String, dynamic> map) {
    return AboutInfo(
      text: _string(
        map['text'],
        fallback:
            'I focus on product outcomes, accessibility, and maintainable code.',
      ),
      skills: _stringList(map['skills']),
    );
  }
}

class PortfolioProject {
  PortfolioProject({
    required this.title,
    required this.year,
    required this.description,
    required this.tags,
    required this.image,
    required this.galleryImages,
    required this.videos,
    required this.liveUrl,
    required this.repoUrl,
    required this.caseStudyUrl,
  });

  final String title;
  final String year;
  final String description;
  final List<String> tags;
  final String image;
  final List<String> galleryImages;
  final List<String> videos;
  final String liveUrl;
  final String repoUrl;
  final String caseStudyUrl;

  factory PortfolioProject.fromMap(Map<String, dynamic> map) {
    return PortfolioProject(
      title: _string(map['title'], fallback: 'Untitled Project'),
      year: _string(map['year'], fallback: ''),
      description: _string(map['description'], fallback: ''),
      tags: _stringList(map['tags']),
      image: _string(
        map['image'],
        fallback: 'assets/images/projects/placeholder.jpg',
      ),
      galleryImages: _stringList(map['galleryImages']),
      videos: _stringList(map['videos']),
      liveUrl: _string(map['liveUrl']),
      repoUrl: _string(map['repoUrl']),
      caseStudyUrl: _string(map['caseStudyUrl']),
    );
  }
}

String _string(Object? value, {String fallback = ''}) {
  if (value is String && value.trim().isNotEmpty) {
    return value.trim();
  }
  return fallback;
}

List<String> _stringList(Object? value) {
  if (value is List) {
    return value
        .whereType<String>()
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
  return <String>[];
}
