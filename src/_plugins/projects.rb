module Jekyll

  class Project
    include Convertible

    attr_accessor :title, :icon, :short_desc
    ATTRIBUTES_FOR_LIQUID = %w[icon title short_desc]

    def initialize(project)
      @title = project['title']
      @icon = project['icon']
      @short_desc = project['short_desc']
    end

  end

  class ProjectPage < Page
    def initialize(site, base, dir, project)
      #super(site, base, dir, 'index.html')
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'project_index.html')

      self.data['project'] = project
      self.data['title'] = "#{project['title']}"
    end
  end

  class ProjectPageGenerator < Generator
    def generate(site)
      projects = []
      site.config['prj'] = []
      if site.layouts.key? 'project_index'
        dir = site.config['projects_dir'] || 'projects'
        site.config['projects'].each do |project|
          projects << Project.new(project[1])
          a = ProjectPage.new(site, site.source, File.join(dir, project[0]), project[1])
          site.pages << a
          site.config['prj'] << a
        end
        #site.config['projects'] = projects
      end
    end
  end

end
