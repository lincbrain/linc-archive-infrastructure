resource "aws_route53_zone" "linc-brain-mit" {
  name = "lincbrain.org"
}

resource "aws_route53_record" "gui" {
  zone_id = aws_route53_zone.linc-brain-mit.zone_id
  name    = "" # apex
  type    = "A"
  ttl     = "300"
  records = ["75.2.60.5"] # Netlify's load balancer,  which will proxy to our app -- https://docs.netlify.com/domains-https/custom-domains/configure-external-dns/#configure-an-apex-domain
}

# resource "aws_route53_record" "gui-staging" {
#   zone_id = aws_route53_zone.linc-brain-mit.zone_id
#   name    = "gui-staging"
#   type    = "CNAME"
#   ttl     = "300"
#   records = ["staging--gui-staging-lincbrain-org.netlify.app"]
# }

resource "aws_acm_certificate" "cert" {
  domain_name        = "lincbrain.org"
  validation_method  = "DNS"

  subject_alternative_names = [
    "*.lincbrain.org"
  ]
}


resource "aws_route53_record" "validation" {
  for_each = {
    for domain_validation_option in aws_acm_certificate.cert.domain_validation_options : domain_validation_option.domain_name => {
      name   = domain_validation_option.resource_record_name
      record = domain_validation_option.resource_record_value
      type   = domain_validation_option.resource_record_type
    }
  }

  zone_id = aws_route53_zone.linc-brain-mit.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = "300"

  lifecycle {
    create_before_destroy = true
    ignore_changes = [records, name, type]
  }
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}

resource "aws_route53_record" "email" {
  zone_id = aws_route53_zone.linc-brain-mit.zone_id
  name    = "" # apex
  type    = "MX"
  ttl     = "300"
  records = [
    "10 mx1.improvmx.com.",
    "20 mx2.improvmx.com.",
  ]
}

resource "aws_route53_record" "email-spf" {
  zone_id = aws_route53_zone.linc-brain-mit.zone_id
  name    = "" # apex
  type    = "TXT"
  ttl     = "300"
  records = ["v=spf1 include:spf.improvmx.com ~all"]
}

resource "aws_route53_record" "docs" {
  zone_id = aws_route53_zone.linc-brain-mit.zone_id
  name    = "docs"
  type    = "CNAME"
  ttl     = "300"
  records = ["lincbrain.github.io."]
}

resource "aws_route53_record" "dashboard" {
  zone_id = aws_route53_zone.linc-brain-mit.zone_id
  name    = "dashboard"
  type    = "CNAME"
  ttl     = "300"
  records = ["lincbrain.github.io."]
}

resource "aws_route53_record" "status" {
  zone_id = aws_route53_zone.linc-brain-mit.zone_id
  name    = "status"
  type    = "CNAME"
  ttl     = "300"
  records = ["lincbrain.github.io."]
}