module RedminePortfolioManagement

    module Redmine
        extend self

        def plugin
            ::Redmine::Plugin.find(:redmine_portfolio_management)
        end

        def settings
            if ActiveRecord::Base.connection.table_exists?(:settings) && self.plugin && Setting.plugin_redmine_portfolio_management
                Setting.plugin_redmine_portfolio_management
            else
                plugin.settings[:default]
            end
        end

        def portfolio_management_attribute
            custom_field(:portfolio_management_attribute)
        end
        
        def portfolio_management_manager_attribute
            custom_field(:portfolio_management_manager_attribute)
        end
		
		def portfolio_management_visible_attribute
            custom_field(:portfolio_management_visible_attribute)
        end
        
        def list_portfolio_values
            sql = "Select distinct cf.id,cv.Value from #{CustomValue.table_name} cv,#{CustomField.table_name} cf where cf.id = cv.custom_field_id and cf.type = 'ProjectCustomField' and name = '#{portfolio_management_attribute::name}'"
            portfolios = ActiveRecord::Base.connection.select_all(sql)
            portfolios
        end
        
        def list_projects_portfolio(portfolio_type, portfolio_name)
            sql = "select cv.value,p.id as project_id,p.name,p.identifier,p.parent_id,to_char(p.created_on,'dd/mm/yyyy') as created_on, to_char(p.updated_on,'dd/mm/yyyy') as updated_on, p.is_public from #{CustomValue.table_name} cv, #{Project.table_name} p where cv.customized_id = p.id and cv.customized_type = 'Project' and custom_field_id = #{portfolio_type} and cv.value = '#{portfolio_name}' order by p.created_on"
            projects = ActiveRecord::Base.connection.select_all(sql)
            projects
        end
        
        
        
        
    
		protected
            def custom_field(name)
                CustomField.find_by_name(settings[name.to_sym])
            end
    end
end
