# Record to point gui.lincbrain.org to the Netlify hosted redirector
resource "aws_route53_record" "redirector" {
  zone_id = aws_route53_zone.linc-brain-mit.zone_id
  name    = "gui"
  type    = "CNAME"
  ttl     = "300"
  records = ["redirect-lincbrain-org.netlify.com"]
}
