# resource "aws_api_gateway_rest_api" "lovepop_api" {
#   name        = "Lovepop-API"
#   description = "Lovepop API"
# }

# ############################################################
# #################### PARENT PATH ####################
# resource "aws_api_gateway_resource" "parent_resource" {
#   rest_api_id = aws_api_gateway_rest_api.lovepop_api.id
#   parent_id   = aws_api_gateway_rest_api.lovepop_api.root_resource_id
#   path_part   = var.parent_path
# }

# resource "aws_api_gateway_method" "parent_method" {
#     depends_on    = [ aws_api_gateway_resource.parent_resource ]
#     for_each      = { for action in locals.processed_actions : "${action.path_part}-${action.method}" => action if action.path_part == "" }
#     rest_api_id   = aws_api_gateway_rest_api.lovepop_api.id
#     resource_id   = aws_api_gateway_resource.parent_resource.id
#     http_method   = each.value.method
#     authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "parent_path_integration" {
#     depends_on              = [ aws_api_gateway_resource.parent_resource ]
#     for_each                = { for action in locals.processed_actions : "${action.path_part}-${action.method}" => action if action.path_part == "" }
#     rest_api_id             = aws_api_gateway_rest_api.lovepop_api.id
#     resource_id             = aws_api_gateway_resource.parent_resource.id
#     http_method             = aws_api_gateway_method.parent_method[each.key].http_method
#     integration_http_method = each.value.method
#     type                    = "MOCK"

#     request_templates = {
#         "application/json" = "{\"statusCode\": 200}"
#     }
# }

# resource "aws_api_gateway_method_response" "parent_method_response" {
#     depends_on  = [ aws_api_gateway_method.parent_method ]
#     for_each      = { for action in locals.processed_actions : "${action.path_part}-${action.method}" => action if action.path_part == "" }
#     rest_api_id = aws_api_gateway_rest_api.lovepop_api.id
#     resource_id = aws_api_gateway_resource.parent_resource.id
#     http_method = aws_api_gateway_method.parent_method[each.key].http_method
#     status_code = "200"
# }

# resource "aws_api_gateway_integration_response" "parent_integration_response" {
#     depends_on  = [ aws_api_gateway_integration.parent_path_integration ]
#     for_each      = { for action in locals.processed_actions : "${action.path_part}-${action.method}" => action if action.path_part == "" }
#     rest_api_id = aws_api_gateway_rest_api.lovepop_api.id
#     resource_id = aws_api_gateway_resource.parent_resource.id
#     http_method = aws_api_gateway_method.parent_method[each.key].http_method
#     status_code = "200"
# }

# ################################################################################
# #################### CHILD PATH ####################
# resource "aws_api_gateway_resource" "child_resource" {
#   depends_on  = [ aws_api_gateway_method.parent_method ]
#   for_each      = { for action in locals.processed_actions : "${action.path_part}-${action.method}" => action if action.path_part != "" }
#   rest_api_id = aws_api_gateway_rest_api.lovepop_api.id
#   parent_id   = aws_api_gateway_resource.parent_resource.id
#   path_part   = each.value.path_part
# }

# resource "aws_api_gateway_method" "child_method" {
#     depends_on    = [ aws_api_gateway_resource.child_resource ]
#   for_each      = { for action in locals.processed_actions : "${action.path_part}-${action.method}" => action if action.path_part != "" }
#     rest_api_id   = aws_api_gateway_rest_api.lovepop_api.id
#     resource_id   = aws_api_gateway_resource.child_resource[each.key].id
#     http_method   = each.value.method
#     authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "child_path_integration" {
#     depends_on              = [ aws_api_gateway_resource.child_resource ]
#   for_each      = { for action in locals.processed_actions : "${action.path_part}-${action.method}" => action if action.path_part != "" }
#     rest_api_id             = aws_api_gateway_rest_api.lovepop_api.id
#     resource_id             = aws_api_gateway_resource.child_resource[each.key].id
#     http_method             = aws_api_gateway_method.child_method[each.key].http_method
#     integration_http_method = each.value.method
#     type                    = "MOCK"

#     request_templates = {
#         "application/json" = "{\"statusCode\": 200}"
#     }
# }

# resource "aws_api_gateway_method_response" "child_method_response" {
#     depends_on  = [ aws_api_gateway_method.child_method ]
#   for_each      = { for action in locals.processed_actions : "${action.path_part}-${action.method}" => action if action.path_part != "" }
#     rest_api_id = aws_api_gateway_rest_api.lovepop_api.id
#     resource_id = aws_api_gateway_resource.child_resource[each.key].id
#     http_method = aws_api_gateway_method.child_method[each.key].http_method
#     status_code = "200"
# }

# resource "aws_api_gateway_integration_response" "child_integration_response" {
#     depends_on  = [ aws_api_gateway_integration.child_path_integration ]
#   for_each      = { for action in locals.processed_actions : "${action.path_part}-${action.method}" => action if action.path_part != "" }
#     rest_api_id = aws_api_gateway_rest_api.lovepop_api.id
#     resource_id = aws_api_gateway_resource.child_resource[each.key].id
#     http_method = aws_api_gateway_method.child_method[each.key].http_method
#     status_code = "200"
# }

# ##############
# resource "aws_api_gateway_method" "default_method" {
#     depends_on    = [ aws_api_gateway_resource.parent_resource, aws_api_gateway_resource.child_resource ]
#   for_each      = { for action in locals.processed_actions : "${action.path_part}-${action.method}" => action}
#     rest_api_id   = aws_api_gateway_rest_api.lovepop_api.id
#     resource_id   = each.value.path_part == "" ? aws_api_gateway_resource.parent_resource.id : aws_api_gateway_resource.child_resource[each.key].id
#     http_method   = "OPTIONS"
#     authorization = "NONE"
# }
# ##############