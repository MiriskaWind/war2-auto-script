--[[
    本脚本适用于任意分辨率的设备。
--]]
init(0); --以当前应用 Home 键在右边初始化
require("TSLib") --调用触动函数库
require("lib") --调用关键函数库
bid = frontAppBid() --当前应用包名
w,h = getScreenSize();
t_delay = 500 --全局延迟变量
target_city = 3 --目标刷野城市
floor = 3 --刷野圈数
num_officer = 10 --可用军官数量
pilot_tab = {} --NPC合集。
city_collect() --城市合集
zuobiao(city_coordinate[target_city][1],city_coordinate[target_city][2])
--判断是否在刷野城市
repeat mSleep(50) until now_wid() == "地图区"
location_x,location_y = city_coordinate[target_city][1],city_coordinate[target_city][2]
location_wid,location_tab = widget.find({["id"]=bid..":id/city_location"})
if location_tab["text"] == location_x..","..location_y then
    nLog(os.date("[%X]:", getNetTime()).."当前在在刷野城！")
else
    zuobiao(city_coordinate[target_city][1],city_coordinate[target_city][2]) --移动到目标
    ttap(w/2-1,h/2-1) --点击地图中心
    mSleep(500)
    text_click("进入")
    --等待进入军事区
    repeat mSleep(50) until now_wid() == "军事区"
end
--以下为野地坐标，按顺序刷野
function coordinate_npc(...) --npc坐标查找
    local wid,tab = widget.find({["id"]=bid..":id/coordinate"})
    num1,num2 = string.find(tab["text"],",")
    x = string.sub(tab["text"],2,num1-1)
    y = string.sub(tab["text"],num1+1,-2)
    npc_type = now_wid()
    if string.sub(npc_type,1,18) == "游隼飞行大队" then
        n = 2
    elseif string.sub(npc_type,1,18) == "苍鹰飞行联队" then
        n = 1
    else
        n = 0
    end
    return x,y,n,npc_type
end
if now_wid() == "军事区" then
    text_click("地图区")
else
    text_click("军事区")
    text_click("地图区")
end
repeat mSleep(50) until now_wid() == "地图区"
local map_wid = widget.find({["id"]=bid..":id/game_menu"})
local x1,y1,x2,y2 = widget.region(map_wid)
local mid_x,mid_y = math.ceil((x1+x2)/2),math.ceil((y1+y2)/2)
local base_a = 0
function polot_find(...)
    local point = findMultiColorInRegionFuzzyExt(0x6ca41e, "0|1|0x558a27,47|1|0x548b27,47|0|0x6ca51f,16|52|0xffffff,16|57|0xffffff,16|63|0xffffff,28|-21|0xd2ff01,28|-12|0xd2ff01", 95, x1, y1, x2, y2, { orient = 1 })
    if #point ~= 0 then  --如返回的table不为空（至少找到一个符合条件的点）
        for var = 1,#point do
            tap(point[var].x,point[var].y)
            repeat mSleep(200) until now_wid() ~= "地图区"
            local x,y,n,npc_type = coordinate_npc(...)
            local arr = {x,y,n,npc_type}
            if Inarr(arr,pilot_tab) then
            else
                base_a = base_a + 1
                table.insert(pilot_tab,{x,y,n})
                nLog(os.date("[%X]:", getNetTime()).."第"..base_a.."个NPC坐标："..x..","..y.."。NPC类型："..npc_type.."，刷野次数："..n)
            end
            button_click("exit_button")
            repeat mSleep(200) until now_wid() == "地图区"
        end
    end
end
--循环找图，逆时针方向。
mSleep(1400)
polot_find(...)
local j = math.pow((floor*2)+1,2) --找图次数
for i = 1,j,1 do
    local m = math.ceil(math.sqrt(i))
    if m%2 == 0 then
        m = m+1
    end
    local n = i-((m-2)*(m-2))
    local l = m*m-(m-2)*(m-2)
    if i%(m*m) == 0 or n >= l*0.75 then
        moveTo(mid_x,y1,mid_x,y2,{["step"] = 400,["ms"] = 10,["index"] = 1,["stop"] = 1}) --向上移动地图
        mSleep(1400)
        polot_find(...)
    elseif n < l*0.25 then
        moveTo(x1,mid_y,x2,mid_y,{["step"] = 400,["ms"] = 10,["index"] = 1,["stop"] = 1}) --向左移动地图
        mSleep(1400)
        polot_find(...)
    elseif n < l*0.5 then
        moveTo(mid_x,y2,mid_x,y1,{["step"] = 400,["ms"] = 10,["index"] = 1,["stop"] = 1}) --向下移动地图
        mSleep(1400)
        polot_find(...)
    elseif n < l*0.75 then
        moveTo(x2-1,mid_y,x1,mid_y,{["step"] = 400,["ms"] = 10,["index"] = 1,["stop"] = 1}) --向右移动地图
        mSleep(1400)
        polot_find(...)
    end
    mSleep(10)
end
--开始打野
rounds,sum_pilot,pilot_tim,repilot_tim = 0,0,{},{}
for i = 1,#pilot_tab,1 do
    sum_pilot = sum_pilot + pilot_tab[i][3]
end
for k = 1,#pilot_tab,1 do
    zuobiao(pilot_tab[k][1],pilot_tab[k][2])
    mSleep(500)
    for i = 1,pilot_tab[k][3],1 do
        rounds = rounds + 1
        ttap(w/2-1,h/2-1) --点击地图中心
        if i == 1 and pilot_tab[k][3] == 2 then
            troops_set = {{11,110000}} --出征配置。
        else
            troops_set = {{11,80000}} --出征配置。
        end
        Shuaye("袭击",troops_set,"编制:")
        t = time_wait(city_coordinate[target_city][1],city_coordinate[target_city][2],pilot_tab[k][1],pilot_tab[k][2],arms[troops_set[1][1]][14],10,0)
        table.insert(pilot_tim,t)
        table.insert(repilot_tim,getNetTime()+t*2)
        nLog(os.date("[%X]:", getNetTime()).."第"..rounds.."次出征，出征时间为："..t.."秒。".."本轮刷野剩余"..sum_pilot-rounds.."回合。")
        toast("第"..rounds.."次出征，出征时间为："..t.."秒。",500)
        if pilot_tab[k][3] == 1 then
            mSleep(500)
        elseif i == 1 and pilot_tab[k][3] == 2 and rounds < num_officer then
            mSleep(10000)
        elseif i == 1 and pilot_tab[k][3] == 2 and rounds >= num_officer then
            repeat mSleep(1000) until getNetTime() > repilot_tim[rounds-num_officer+1]
        else
            break
        end
    end
    if rounds < num_officer then
        mSleep(500)
    elseif rounds >= num_officer and k ~= #pilot_tab then
        repeat mSleep(1000) until getNetTime() > repilot_tim[rounds-num_officer+1]
    else
        repeat mSleep(1000) until getNetTime() > repilot_tim[#repilot_tim]
    end
end
nLog(os.date("[%X]:", getNetTime()).."本轮刷野结束！")
if sum_pilot ~= 0 then
    mSleep(math.max(table.unpack(pilot_tim))*2000+20000)
end
--本轮刷野结束，迁城
button_click("city_icon_bg_button")
repeat mSleep(50) until now_wid() == "城市信息"
button_click("btn_move_city")
repeat mSleep(50) until now_wid() == "迁城"
button_click("apply_button_a")
repeat
    mSleep(10) 
    local wid,tab = widget.find({["id"]=frontAppBid()..":id/game_alert_title"})
until wid ~= nil
text_click("是")
repeat mSleep(50) until now_wid() == "地图区"
local wid,tab = widget.find({["id"]=bid..":id/city_location"})
nLog(os.date("[%X]:", getNetTime()).."已进行一次迁城！".."本次迁城位置："..tab["text"])
lua_restart()