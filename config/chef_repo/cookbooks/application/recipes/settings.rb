$app = {'id' => 'fakemytweet',
        'deploy_to' => '/srv/fakemytweet',
        'owner' => 'root',
        'group' => 'root',
        'revision' => {'production' => 'master'},
        'force' => {'production' => true},
        'repository' => 'file:///tmp/fakemytweet/.git',
        'migrate' => {'production' => false}}
