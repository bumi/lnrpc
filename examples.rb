require "lnrpc"

lnd = Lnrpc::Client.new() # use defaults for credentials, macaraoon and address

get_info_res = lnd.lightning.get_info
puts get_info_res.alias

puts lnd.lightning.wallet_balance.total_balance

pay_request = "lntb50u1pw9mmndpp5nvnff958pxc9eqknwntyxapjw7l5grt5e2y70cmmnu0lljfa0sdqdpsgfkx7cmtwd68yetpd5s9xct5v4kxc6t5v5s8yatz0ysxwetdcqzysxqyz5vqjkhlyn40z76gyn7dx32p9j58dftve9xrlvnqqazht7w2fdauukhyhr9y4k3ngjn8s6srglj8swk7tm70ng54wdkq47ahytpwffvaeusp500csz"
lnd.pay(payment_request: pay_request) # or:
lnd.router.send_payment_v2(payment_request: pay_request)

dest = Lnrpc.to_byte_array('038474ec195f497cf4036e5994bd820dd365bb0aaa7fb42bd9b536913a1a2dcc9e')
lnd.keysend(dest: dest, amt: 1000)

invoice_res = lnd.lightning.add_invoice(value: 1000, memo: 'I :heart: ruby')
puts invoice_res.payment_request

puts lnd.versioner.get_version
puts lnd.wallet_kit.estimate_fee(conf_target: 10)
puts lnd.wallet_kit.next_addr

channel = lnd.lightning.list_channels.channels[0]
puts lnd.lightning.get_chan_info(chan_id: channel.chan_id)
channel_point = {
  funding_txid_str: channel.channel_point.split(":")[0],
  output_index: channel.channel_point.split(":")[1].to_i
}
lnd.lightning.update_channel_policy({
  time_lock_delta: 40,
  base_fee_msat: 1100,
  chan_point: channel_point
})

#lnd.lightning.subscribe_invoices(settle_index: 1).each do |invoice|
#  puts invoice.payment_request
#end
