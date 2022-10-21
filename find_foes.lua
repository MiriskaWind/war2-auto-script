--[[
    本脚本适用于任意分辨率的设备。
--]]
init(0); --以当前应用 Home 键在右边初始化
require("TSLib") --调用触动函数库
require("lib") --调用关键函数库
bid = frontAppBid()
t_delay = 500 --全局延迟变量
w,h = getScreenSize();
pilot_tab = {}
function coordinate_npc(...) --npc坐标查找
    local wid1,tab1 = widget.find({["id"]=bid..":id/coordinate"})
    local wid2,tab2 = widget.find({["id"]=bid..":id/dialog_map_occupiedzon_textview1"})
    num1,num2 = string.find(tab1["text"],",")
    x = string.sub(tab1["text"],2,num1-1)
    y = string.sub(tab1["text"],num1+1,-2)
    Commander = tab2["text"]
    city = now_wid()
    return x,y,city,Commander
end
if now_wid() == "军事区" then
    text_click("地图区")
end
repeat mSleep(10) until now_wid() == "地图区"
zuobiao(275,275)
local map_wid = widget.find({["id"]=bid..":id/game_menu"})
local x1,y1,x2,y2 = widget.region(map_wid)
local mid_x,mid_y = math.ceil((x1+x2)/2),math.ceil((y1+y2)/2)
n = 0
function polot_find(...)
    local point = findMultiColorInRegionFuzzyExt(0x8c110d, "5|-6|0x95130e,5|4|0x700e0a,11|-1|0x730e0a,5|-1|0x83100c", 100, x1, y1, x2, y2, { orient = 1 })
    if #point ~= 0 then  --如返回的table不为空（至少找到一个符合条件的点）
        for var = 1,#point do
            n = n + 1
            tap(point[var].x+50,point[var].y+10)
            repeat mSleep(100) until now_wid() ~= "地图区"
            local x,y = coordinate_npc(...)
            table.insert(pilot_tab,{x,y,n})
            nLog("第"..n.."个npc坐标："..x..","..y..",统帅名称："..Commander..",城市："..city)
            button_click("exit_button")
            repeat mSleep(100) until now_wid() == "地图区"
        end
    end
end
polot_find(...)
--循环找图
local j = 4000 --找图次数
for i = 1,j,1 do
    local m = math.ceil(math.sqrt(i))
    if m%2 == 0 then
        m = m+1
    end
    local n = i-((m-2)*(m-2))
    local l = m*m-(m-2)*(m-2)
    if i%(m*m) == 0 or n >= l*0.75 then
        k = "Up"
        moveTo(mid_x,y1,mid_x,y2,{["step"] = 100,["ms"] = 10,["index"] = 1,["stop"] = 1}) --向上移动地图
        mSleep(1200)
        polot_find(...)
    else 
        if n < l*0.25 then
            k = "Lfet"
            moveTo(x1,mid_y,x2,mid_y,{["step"] = 100,["ms"] = 10,["index"] = 1,["stop"] = 1}) --向左移动地图
            mSleep(1200)
            polot_find(...)
        else
            if n < l*0.5 then
                k = "Down"
                moveTo(mid_x,y2,mid_x,y1,{["step"] = 100,["ms"] = 10,["index"] = 1,["stop"] = 1}) --向下移动地图
                mSleep(1200)
                polot_find(...)
            else
                if n < l*0.75 then
                    k = "Right"
                    moveTo(x2-1,mid_y,x1,mid_y,{["step"] = 100,["ms"] = 10,["index"] = 1,["stop"] = 1}) --向右移动地图
                    mSleep(1200)
                    polot_find(...)
                end
            end
        end
    end
    -- nLog(i.."+++"..m.."+++"..n.."+++"..l.."+++"..k)
    mSleep(10)
end
--开始打野
