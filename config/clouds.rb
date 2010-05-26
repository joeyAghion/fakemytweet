
pool :fakemytweet do
  
  cloud :app do
    # access_key "AKIAI2RX4SCC4F672KLA"
    # secret_access_key "ylMUBDku1E949iEwvS3LwXgqmPsxZ0hKyoLf/j5i"
    # private_key "/Users/joey/.ssh/pk-fakemytweet.pem"
    # cert "/Users/joey/.ssh/cert-fakemytweet.pem"
    instances 1
    keypair "/Users/joey/.ec2/fakemytweet.pem"
    
    using :ec2 do
      # image_id 'ami-ecf61585' # Alestic Ubuntu
      # image_id 'ami-40917c29' # Old: unregister and delete, then delete this line
      # image_id 'ami-acd538c5' # Weplay Build Server AMI
      # instance_type 'm1.small'
      # availability_zones ['us-east-1b']
    end
    
    chef do
      repo File.join(File.dirname(__FILE__), 'chef_repo')
      attributes :hostname => 'fakemytweet.com',
                 :app      => {:name => 'fakemytweet'},
                 :unicorn  => {:version => '0.99.0', :port => 3000, :options => {:backlog => 1024, :tcp_nodelay => true}},
                 :app_environment => 'production',
                 :apps     => {'fakemytweet' => {'production' => {:run_migrations => false}}},
                 :rails    => {:version => '2.3.5'}
      recipe 'rubygems'
      recipe 'ruby_enterprise'
#      recipe 'ruby'
      recipe 'nginx::default'
      recipe 'rails_enterprise'
#      recipe 'rails'
      #recipe 'unicorn'
      recipe 'application::rails'
      recipe 'application::unicorn'
      # recipe "apache2"
      # attributes :apache2 => {:listen_ports => ["80", "8080"]}
      # recipe "passenger_enterprise"
      # recipe "rsyslog::server"
      # recipe "collectd"
    end

    security_group do
      authorize :from_port => 22, :to_port => 22
      authorize :from_port => 80, :to_port => 80
      authorize :from_port => 3000, :to_port => 3000
    end
  end
end
