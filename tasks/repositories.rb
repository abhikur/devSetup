class Repositories
  ALL = %w(cas
            authorization_service
            promotion_service 
            promotion_app 
            promotion_planning_service 
            generated_properties
            infrastructure
                  )

  BUNDLED = Dir.glob('../*/Gemfile').map { |x| x.split('/')[1] }.select { |repo| ALL.include?(repo) }
  NON_BUNDLED = ALL - BUNDLED
  REPOSITORIES_WITH_DB = Dir.glob('../*/config/{database,mongoid}.yml').map { |x| x.split('/')[1] }.select { |repo| ALL.include?(repo) }
  SERVICES = Dir.glob('../*/config.ru').map { |x| x.split('/')[1] }.select { |repo| ALL.include?(repo) }
end
