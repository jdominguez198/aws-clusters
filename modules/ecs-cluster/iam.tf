# https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${module.ecs.ecs_cluster_name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_ssm_role" {
  name = "${module.ecs.ecs_cluster_name}-task-ssm-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_policy" "ecs_task_ssm_policy" {
  name = "${module.ecs.ecs_cluster_name}-task-ssm-policy"
  path = "/"

  policy = file("${path.module}/iam/iam_ssm_policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_task_ssm_policy_attachment" {
  role = aws_iam_role.ecs_task_ssm_role.id
  policy_arn = aws_iam_policy.ecs_task_ssm_policy.arn
}
