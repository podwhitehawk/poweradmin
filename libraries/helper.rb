# getting md5 hash of user password
def getMD5pass?
  require 'digest/md5'
  return Digest::MD5.hexdigest(node["poweradmin"]["password"])
end
