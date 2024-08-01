### modules/storage/outputs.tf ###

output "efs" {
  value = aws_efs_file_system.efs_token.creation_token
}