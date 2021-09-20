module "ecs-eip" {
  source = "../../modules/elastic-ip"

  name = local.ecs_elastic_ip_name
}

module "ecs-sample" {
  source = "../../modules/ecs-cluster"

  cluster_name = local.ecs_cluster_name
  name_prefix = local.ecs_cluster_prefix
  eip_name = local.ecs_elastic_ip_name
  region = local.ecs_cluster_region
  region_zone_01 = local.ecs_cluster_region_zone_01
  region_zone_02 = local.ecs_cluster_region_zone_02
  region_zone_03 = local.ecs_cluster_region_zone_03
  generic_service_discovery_namespace = local.ecs_generic_service_discovery_name

  depends_on = [
    module.ecs-eip.eip_01_id,
    module.ecs-eip.eip_02_id
  ]
}
