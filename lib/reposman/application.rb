module Reposman
  class Application
    def initialize (options = Options.new)
      @options = options

      @umasks = []
    end

    attr_reader :options

    def run!
      log("Running in test mode") if options.test

      options.url << "/" unless options.url.end_with?("/")
      unless File.directory?(options.repo_base)
        log("The directory #{options.repo_base} doesn't exist", exit => true)
      end

      begin
        log("Querying ChiliProject for projects...", :level => 1);
        projects = project_class.all(:params => {:key => options.api_key})
      rescue => e
        log("ERROR: Unable to connect to #{Project.site}: #{e}", :exit => true)
      end

      if projects.nil?
        log('ERROR: No project found, perhaps you forgot to "Enable WS for repository management"', :exit => 0)
      end

      log("Retrieved #{projects.size} projects", :level => 1)
      projects.each{|p| log("\t#{p.identifier}", :level => 2)}

      projects.each do |project|
        handle_project(project)
      end
    end

    def project_class
      @project_class ||= begin
        cls = Class.new(Reposman::Project)
        cls.site = options.chiliproject
        cls
      end
    end

    def handle_project(project)
      log("Handling project #{project.name}", :level => 1)
      if project.identifier.empty?
        log("\tNo identifier given for project #{project.name}")
        return
      elsif not project.identifier.match(/^[a-z0-9\-_]+$/)
        log("\tInvalid identifier for project #{project.name}: #{project.identifier}");
        return;
      end

      repos_path = File.join(options.repos_base, project.identifier)
      repos_path.gsub!(File::SEPARATOR, File::ALT_SEPARATOR || File::SEPARATOR)

      if File.directory?(repos_path)
        update_mode(repos_path)
      else
        create_repository(project, repos_path)
      end

    end

    def update_mode(repos_path)
      return log("\tchange mode on #{repos_path}") if options.test?

      # TODO: update mode
      # TODO: set_gid
    end

    def create_repository(project, repos_path)
      if !options.force? && project.respond_to?(:repository)
        log("\trepository for project #{project.identifier} is already configured in ChiliProject", :level => 1)
        return
      end

      begin
        set_owner_and_rights(repos_path) do
          run_command()



      if options.test?
        log("\tCreated repository #{repos_path}")
      end






    end

    def set_umask
      umask = 777 - options.mask
      @umasks << File.umask(umask)
    end

    def pop_umask
      File.umask(@umasks.pop)
    end

    def self.log(text, options, args={})
      level = args[:level] || 0
      puts text unless options.quiet or level > options.verbose
      exit args[:exit].to_i if args[:exit]
    end

    def log(text, args={})
      self.class.log(text, options, args)
    end
  end
end