class s3 {

    package { 'aws-sdk':
        ensure   => present,
        provider => 'pe_gem',
    }

    Package ['rubygems'] -> Package ['aws-sdk'] -> S3 <| |>
}
