import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/link_utils.dart';
import '../../core/widgets/action_button.dart';
import '../../core/widgets/gradient_background.dart';
import '../../core/widgets/image_fallback.dart';
import '../../core/widgets/staggered_fade_in.dart';
import '../../data/models/portfolio_data.dart';
import '../../data/repositories/portfolio_repository.dart';
import '../projects/project_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.repository = const PortfolioRepository()});

  final PortfolioRepository repository;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Future<PortfolioData> _dataFuture = widget.repository.load();
  String _selectedTag = 'All';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PortfolioData>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(
              child: Text(
                'Unable to load assets/data/site.json\n${snapshot.error ?? ''}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final data = snapshot.data!;
        final allTags = <String>{};
        for (final project in data.projects) {
          allTags.addAll(project.tags);
        }
        final filters = ['All', ...allTags.toList()..sort()];
        final filteredProjects = _selectedTag == 'All'
            ? data.projects
            : data.projects
                  .where((p) => p.tags.contains(_selectedTag))
                  .toList();

        return Scaffold(
          body: Stack(
            children: [
              const GradientBackground(),
              SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: StaggeredFadeIn(
                            delayMs: 0,
                            child: _TopBar(owner: data.owner),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: StaggeredFadeIn(
                            delayMs: 80,
                            child: _HeroSection(data: data),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: StaggeredFadeIn(
                            delayMs: 120,
                            child: _AboutSection(data: data),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: StaggeredFadeIn(
                            delayMs: 160,
                            child: _ProjectHeader(
                              filters: filters,
                              selectedTag: _selectedTag,
                              onSelected: (tag) =>
                                  setState(() => _selectedTag = tag),
                            ),
                          ),
                        ),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 360,
                                  mainAxisSpacing: 14,
                                  crossAxisSpacing: 14,
                                  mainAxisExtent: 380,
                                ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) =>
                                  ProjectCard(project: filteredProjects[index]),
                              childCount: filteredProjects.length,
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: StaggeredFadeIn(
                            delayMs: 220,
                            child: _Footer(data: data),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.owner});

  final OwnerProfile owner;

  @override
  Widget build(BuildContext context) {
    final initials = owner.name
        .split(' ')
        .where((word) => word.trim().isNotEmpty)
        .take(2)
        .map((word) => word[0].toUpperCase())
        .join();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.cardAlt,
            child: Text(
              initials.isEmpty ? 'MP' : initials,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Wrap(
            spacing: 10,
            children: const [
              _TopNavChip(label: 'Projects'),
              _TopNavChip(label: 'About'),
              _TopNavChip(label: 'Contact'),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopNavChip extends StatelessWidget {
  const _TopNavChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      backgroundColor: AppColors.card,
      side: const BorderSide(color: AppColors.border, width: 1.5),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.data});

  final PortfolioData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 850;
          final left = _HeroContent(data: data);
          final right = _HeroImage(startup: data.startup);

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [right, const SizedBox(height: 20), left],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 6, child: left),
              const SizedBox(width: 20),
              Expanded(flex: 4, child: right),
            ],
          );
        },
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  const _HeroContent({required this.data});

  final PortfolioData data;

  @override
  Widget build(BuildContext context) {
    final owner = data.owner;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PORTFOLIO',
          style: TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 6),
        Text(owner.name, style: Theme.of(context).textTheme.displaySmall),
        const SizedBox(height: 8),
        Text(
          owner.role,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(owner.bio, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ActionButton(
              label: 'View Resume',
              onPressed: () => openUrl(owner.resumeUrl),
              filled: true,
            ),
            ActionButton(
              label: owner.email,
              onPressed: () => openUrl('mailto:${owner.email}'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _FlutterBadge(label: 'Flutter'),
            _FlutterBadge(label: 'Dart'),
            _FlutterBadge(label: 'Firebase'),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: data.socials
              .map(
                (social) => ActionButton(
                  label: social.label,
                  onPressed: () => openUrl(social.url),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.startup});

  final StartupInfo startup;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: AppColors.card,
        border: Border.all(color: AppColors.border, width: 2.2),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.glow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEDE3FF), Color(0xFFDCCBFF)],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.96),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFBFA5F6),
                    width: 1.2,
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: Image.asset(
                  startup.image,
                  width: double.infinity,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  errorBuilder: (context, error, stackTrace) =>
                      const ImageFallback(label: 'Add startup image'),
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            decoration: const BoxDecoration(color: AppColors.cardAlt),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.flutter_dash,
                      color: AppColors.accent,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        startup.name,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  startup.tagline,
                  style: const TextStyle(color: AppColors.textMuted),
                ),
                if (startup.url.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ActionButton(
                    label: 'Visit Startup',
                    onPressed: () => openUrl(startup.url),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FlutterBadge extends StatelessWidget {
  const _FlutterBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.cardAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.flutter_dash, color: AppColors.accent, size: 16),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.data});

  final PortfolioData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ABOUT',
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text('How I work', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
          Text(data.about.text, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: data.about.skills
                .map(
                  (skill) => Chip(
                    label: Text(
                      skill,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    side: const BorderSide(color: AppColors.border, width: 1.2),
                    backgroundColor: AppColors.card,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _ProjectHeader extends StatelessWidget {
  const _ProjectHeader({
    required this.filters,
    required this.selectedTag,
    required this.onSelected,
  });

  final List<String> filters;
  final String selectedTag;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 34, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PROJECTS',
            style: TextStyle(
              color: AppColors.accent,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Selected work',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filters
                .map(
                  (tag) => ChoiceChip(
                    label: Text(
                      tag,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    selected: tag == selectedTag,
                    backgroundColor: AppColors.card,
                    selectedColor: AppColors.accentStrong,
                    side: const BorderSide(color: AppColors.border, width: 1.2),
                    onSelected: (_) => onSelected(tag),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatefulWidget {
  const ProjectCard({required this.project, super.key});

  final PortfolioProject project;

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectDetailPage(project: project),
          ),
        ),
        child: AnimatedScale(
          scale: _hover ? 1.004 : 1,
          duration: const Duration(milliseconds: 110),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 110),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: AppColors.card,
              border: Border.all(color: AppColors.border, width: 2),
              borderRadius: BorderRadius.circular(18),
              boxShadow: _hover
                  ? const [
                      BoxShadow(
                        color: AppColors.glow,
                        blurRadius: 14,
                        spreadRadius: 0.5,
                        offset: Offset(0, 4),
                      ),
                    ]
                  : const [],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 170,
                  width: double.infinity,
                  child: Hero(
                    tag: 'project-image-${project.title}',
                    child: Image.asset(
                      project.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          ImageFallback(label: project.title),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              project.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Text(
                            project.year,
                            style: const TextStyle(color: AppColors.textMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        project.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: project.tags
                            .map(
                              (tag) => Chip(
                                label: Text(
                                  tag,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                visualDensity: VisualDensity.compact,
                                backgroundColor: AppColors.cardAlt,
                                side: const BorderSide(color: AppColors.border),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Open project details',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({required this.data});

  final PortfolioData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 34, 20, 28),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.cardAlt,
          border: Border.all(color: AppColors.border, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Let\'s build something meaningful.',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              data.owner.email,
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Last updated: ${data.lastUpdated}',
              style: const TextStyle(color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
