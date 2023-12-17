# module "api_gateway" {
#   source = "./modules/api-gateway"
  
#   parent_path = "Card"

#   actions = [
#     {
#       path_part = ""
#       method = "GET"
#     },
#     { 
#       path_part = ""
#       method = "POST"
#     },
#     {
#       path_part = "Compress"
#       method = "POST"
#     },
#     {
#       path_part = "GetList"
#       method = "GET"
#     },
#     {
#       path_part = "{id}"
#       method = "GET"
#     },
#     {
#       path_part = "{id}"
#       method = "DELETE"
#     }
#   ]
# }