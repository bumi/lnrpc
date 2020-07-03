require "lnrpc"

lnd = Lnrpc::Client.new() # use defaults for credentials, macaraoon and address

get_info_res = lnd.lightning.get_info
puts get_info_res.alias

puts lnd.lightning.wallet_balance.total_balance

pay_request = "lntb50u1pw9mmndpp5nvnff958pxc9eqknwntyxapjw7l5grt5e2y70cmmnu0lljfa0sdqdpsgfkx7cmtwd68yetpd5s9xct5v4kxc6t5v5s8yatz0ysxwetdcqzysxqyz5vqjkhlyn40z76gyn7dx32p9j58dftve9xrlvnqqazht7w2fdauukhyhr9y4k3ngjn8s6srglj8swk7tm70ng54wdkq47ahytpwffvaeusp500csz"
lnd.pay(pay_request) # or:
lnd.router.send_payment_v2(payment_request: pay_request)

invoice_res = lnd.lightning.add_invoice(value: 1000, memo: 'I :heart: ruby')
puts invoice_res.payment_request

lnd.lightning.subscribe_invoices(settle_index: 1).each do |invoice|
  puts invoice.payment_request
end
