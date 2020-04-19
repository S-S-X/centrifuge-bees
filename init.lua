--[[
  Dig beehives while keeping inventory count information.
  Add centrifuge recipe for beehives with honey in inventory.
--]]

minetest.override_item("mobs:beehive", {
	on_dig = function(pos, node, digger)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		local honey = inv:get_stack("beehive", 1):get_count()
		local stack = "mobs:beehive"
		if honey > 0 then
			stack = stack .. "_" .. honey
		end
		--minetest.node_dig(pos, node, digger)
		minetest.handle_node_drops(pos, {stack}, digger)
		minetest.remove_node(pos)
	end,
	can_dig = nil,
})

-- register recipes forr beehive items
for i = 1, 12 do
  minetest.register_craftitem(":mobs:beehive_" .. i, {
    description = S("Beehive") .. ": " .. S("Honey") .. string.format(" %d/12", i),
    inventory_image = "mobs_beehive.png",
    groups = {oddly_breakable_by_hand = 3, flammable = 1, not_in_creative_inventory=1},
    on_place = function(itemstack, placer, pointed_thing)
      local stack, pos = minetest.item_place(ItemStack("mobs:beehive"), placer, pointed_thing)
      if pos then
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local name = itemstack:get_name()
        inv:add_item("beehive", "mobs:honey " .. string.sub(name, 14))
        itemstack:take_item(1)
      end
      return itemstack
    end,
  });
  technic.register_separating_recipe({
    input = {"mobs:beehive_" .. i .. " 1"},
    output = {"mobs:beehive", "mobs:honey " .. i},
    time = math.min(6, i)
  })
end
