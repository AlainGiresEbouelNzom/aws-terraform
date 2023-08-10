
resource "aws_cloudfront_distribution" "demo_cloudfront" {
  origin {
    domain_name              = aws_lb.demo-alb.dns_name
    # origin_access_control_id = aws_cloudfront_origin_access_control.default.id
    origin_id                = aws_lb.demo-alb.name
    origin_path = "/"
    custom_origin_config {
        http_port= "80"
        https_port="443"
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols = ["TLSv1.2"]
    }

  }

  enabled             = true
#   default_root_object = "index.html"

  aliases = ["mysite.example.com", "yoursite.example.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_lb.demo-alb.name
    cache_policy_id = "${aws_lb.demo-alb.name}-cache-policy"
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

#   # Cache behavior with precedence 0
#   ordered_cache_behavior {
#     path_pattern     = "/content/immutable/*"
#     allowed_methods  = ["GET", "HEAD", "OPTIONS"]
#     cached_methods   = ["GET", "HEAD", "OPTIONS"]
#     target_origin_id = local.s3_origin_id

#     forwarded_values {
#       query_string = false
#       headers      = ["Origin"]

#       cookies {
#         forward = "none"
#       }
#     }

#     min_ttl                = 0
#     default_ttl            = 86400
#     max_ttl                = 31536000
#     compress               = true
#     viewer_protocol_policy = "redirect-to-https"
#   }

 
  price_class = "PriceClass_100"

  tags = {
    Environment = "demo-distribution"
  }

  restrictions {
    geo_restriction{
        locations = []
        restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = false
    #acm_certificate_arn = aws_acm_certificate.demo-tls-cert.id 
  }
}

resource "aws_acm_certificate" "demo-tls-cert" {
  domain_name       = "numerix-md.com"
  validation_method = "DNS"

  tags = {
    Environment = "demo-test"
  }

  lifecycle {
    create_before_destroy = true
  }
}