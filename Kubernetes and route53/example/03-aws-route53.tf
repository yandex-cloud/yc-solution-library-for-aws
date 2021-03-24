

locals {
  lb_name_parts = split("-", split(".", kubernetes_service.eks_nginx.load_balancer_ingress.0.hostname).0)
}

data "aws_elb" "eks_svc" {
  name = join("-", slice(local.lb_name_parts, 0, length(local.lb_name_parts) - 1))
}



resource "aws_route53_zone" "main" {
  name = "aws-yandex-example.com"
}

resource "aws_route53_record" "www_us" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "aws"
  type    = "A"

  alias {
    name                   = kubernetes_service.eks_nginx.load_balancer_ingress[0].hostname
    zone_id                = data.aws_elb.eks_svc.zone_id
    evaluate_target_health = true
  }
  set_identifier = "us"
  geolocation_routing_policy {
    country = "US"
  }

}



resource "aws_route53_record" "www_ru" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "aws"
  type    = "A"
  ttl     = "5"

  records        = [kubernetes_service.mk8s_nginx.load_balancer_ingress[0].ip]
  set_identifier = "ru"
  geolocation_routing_policy {
    country = "RU"
  }

}

output "r53ns" {
  value = aws_route53_zone.main.name_servers[0]
}
