require 'rubygems' #if Puppet.features.rubygems? 
#require 'aws-sdk-v1'
require 'aws-sdk' #if Puppet.features.awssdk?
require 'aws-sdk-resources'

Puppet::Type.type(:s3).provide(:s3) do
  confine :feature => :awssdk

  desc "Run pupppet on a node"

  def create
    Puppet.info('Connecting to AWS S3')   
    Aws.config( 
        :access_key_id      => @resource[:access_key_id], 
        :secret_access_key  => @resource[:secret_access_key],
        #:region             => @resource[:region] || 'us-east',
    )

    source_ary  = @resource[:source].chomp.split.split('/')
    source_ary.shift # Remove prefixed white space
    
    bucket      = source_ary.shift
    key         = "/" + File.join(source_ary)

    Puppet.info('Setting new S3 object and downloading...')

    s3 = Aws::S3.new
    File.open(@resource[:path], 'wb') do |file|
        resp = s3.get_object(
            target: file,
            bucket: bucket,
            key:    key,
        )
    end

    #File.open(@resource[:path], 'w') do |file|
    #    obj.read do |chunk|
    #        file.write(chunk)
    #    end
    #end
    
  end

  def destroy
    
  end

  def exists?
  
      File.exists? @resource[:path]

  end

end
