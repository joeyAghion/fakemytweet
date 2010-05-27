# execute 'rsync -avz -e "ssh -i /Users/joey/.ec2/fakemytweet.pem" . root@ec2-174-129-106-151.compute-1.amazonaws.com:/tmp/fakemytweet' do
#   cwd "/tmp"
# end

package "libcurl4-gnutls-dev"

ree_gem "json"
ree_gem "typhoeus"
