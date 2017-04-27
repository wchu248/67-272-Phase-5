# require needed files
require 'helpers/validations'
require 'helpers/cart'
require 'helpers/shipping'

# create some helpers for the chess store
module ChessStoreHelpers
  include ChessStoreHelpers::Validations
  include ChessStoreHelpers::Shipping
  include ChessStoreHelpers::Cart
end