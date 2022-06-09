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

lnd.lightning.subscribe_invoices(settle_index: 1).each do |invoice|
  puts invoice.payment_request
end

# sign a message with your node
signed_message = lnd.lightning.sign_message({ msg: "Money printer goes brrr" })
puts "Signature: " + signed_message.signature

# verify a signed message by another node
verification_response = lnd.lightning.verify_message({
  msg: "Money printer goes brrr",
  signature: signed_message.signature
})
puts "Pubkey: " + verification_response.pubkey # pubkey of the node that signed
puts "Valid: " + verification_response.valid.to_s

# get information on a node
node_info_response = lnd.lightning.get_node_info(pub_key: verification_response.pubkey, include_channels: true)
puts "Updated: " + Time.at(node_info_response.node.last_update).to_s
puts "Pubkey: " + node_info_response.node.pub_key.to_s
puts "Alias: " + node_info_response.node.alias.to_s
puts "Color: " + node_info_response.node.color.to_s
puts "Channels: " + node_info_response.num_channels.to_s
puts "Capacity SAT: " + node_info_response.total_capacity.to_s
puts "Address: " + node_info_response.node.addresses.first["addr"].to_s

# extract channel information
node_info_response.channels.each do |channel|
  puts "Channel ID: " + channel["channel_id"].to_s
  puts "Channel 1:" + channel["node1_pub"].to_s # pubkey of the first node
  puts "Channel 2:" + channel["node2_pub"].to_s # pubkey of the second node
  puts "Channel Capacity:" + channel["capacity"].to_s
end

# update channel policy
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
