--[[
    本脚本适用于任意分辨率的设备。
--]]
init(0); --以当前应用 Home 键在右边初始化
require("TSLib") --调用触动函数库
require("lib") --调用关键函数库
wild_times = 5000 --刷野次数
target_city = 6 --任务目标城市
t_delay = 500 --全局延迟变量
w,h = getScreenSize(); --获取设备分辨率
bid = frontAppBid()
mSleep(1000)
--[[
    日常军事任务。
--]]

button_click("btn_menu_icon")
text_click("任务")
repeat mSleep(100) until now_wid() == "任务"
text_click("日常军事")
mSleep(1000)
repeat
    local wid = widget.find({["id"]=bid..":id/btn_task_list_get"})
    if wid then
        button_click("btn_task_list_get")
        mSleep(2000)
        text_click("确定")
    end
until wid == nil
button_click("exit_button")

--[[
    活跃任务。
--]]
function task_01(...)
    city_collect()
    zuobiao(city_coordinate[target_city][1],city_coordinate[target_city][2])
    --判断是否在刷野城市
    repeat mSleep(100) until now_wid() == "地图区"
    location_x,location_y = city_coordinate[target_city][1],city_coordinate[target_city][2]
    location_wid,location_tab = widget.find({["id"]=bid..":id/city_location"})
    nLog(location_tab["text"])
    if location_tab["text"] == location_x..","..location_y then
        nLog("当前在在刷野城！")
    else
        zuobiao(city_coordinate[target_city][1],city_coordinate[target_city][2]) --移动到目标
        ttap(w/2-1,h/2-1) --点击地图中心
        mSleep(500)
        text_click("进入")
        --等待进入军事区
        repeat mSleep(100) until now_wid() == "军事区"
    end
    text_click("资源区")
    mSleep(1000)
    local x,y = findMultiColorInRegionFuzzy(0xd3d6bf, "1|9|0xdfe0cc,24|0|0xdcdccb,25|8|0xdfe0cb", 95, 0, 0, w, h, { orient = 2 })
    if x ~= -1 then
        ttap(x,y)
    end
    text_click("农田")
    text_click("确定建造")
    mSleep(3000)
    local x,y = findMultiColorInRegionFuzzy(0xffffff, "10|-4|0xffffff,7|22|0xffffff,6|10|0xffffff", 95, 0, 0, w, h, { orient = 1 })
    if x ~= -1 then
        ttap(x,y)
    end
    mSleep(1000)
    local x,y = findMultiColorInRegionFuzzy(0xecf5f8, "8|6|0xecf5f8,39|-7|0xecf5f8,47|-16|0xecf5f8,23|-40|0xecf5f8,13|-32|0xecf5f8,-13|-37|0xecf5f8,47|-50|0xecf5f8,55|11|0xecf5f8,-3|15|0xecf5f8", 95, 0, 0, 1920, 1080, { orient = 1 })
    if x ~= -1 then
        ttap(x,y)
    end
    mSleep(1000)
    button_click("building_del_button") --拆除建筑
end --日常活跃任务：建造或升级建筑
function task_02(...)
    button_click("city_icon_bg_button")
    repeat mSleep(100) until now_wid() == "城市信息"
    text_click("军队")
    button_click("cityinfo_list_image_army")
    button_click("training_button")
    mSleep(1000)
    button_click("exit_button")
end --日常活跃任务：训练部队

function task_03(...)
    text_click("地图区")
    repeat mSleep(100) until now_wid() == "地图区"
    x,y = findMultiColorInRegionFuzzy(0x6ca41e, "0|1|0x558a27,47|0|0x6ca51f,47|1|0x548b27", 85, 0, 0, w, h, { orient = 1 })
    if x ~= -1 then
        ttap(x,y)
    end
    local troops_set = {{4,1}}
    Shuaye("袭击",troops_set,"编制:")
end --日常活跃任务：袭击NPC

function task_04(...)
    -- body
end --日常活跃任务:采集资源
function task_05(...)
    repeat mSleep(100) until now_wid() == "军事区" or now_wid() == "地图区"
    button_click("btn_menu")
    mSleep(500)
    text_click("商城")
    repeat mSleep(100) until now_wid() == "商城"
    text_click("战争消耗")
    mSleep(1000)
    text_click("5")
    mSleep(500)
    button_click("button_pay")
    mSleep(500)
    button_click("exit_button")
end --日常活跃任务：购买宝物

function task_06(...)
    repeat mSleep(100) until now_wid() == "军事区" or now_wid() == "地图区"
    button_click("btn_menu")
    mSleep(500)
    text_click("宝物")
    mSleep(500)
    text_click("奖章")
    mSleep(500)
    text_click("筛选")
    button_click("medal_filter_check")
    mSleep(500)
    text_click("确定")
    mSleep(500)
    button_click("treasure_item_icon")
    mSleep(500)
    button_click("baptize_button")
    mSleep(500)
    button_click("baptize_btn")
    mSleep(500)
    text_click("确定")
    mSleep(500)
    text_click("确定")
    mSleep(500)
    button_click("exit_button")
end --日常活跃任务：奖章洗练
task_06()
function task_07(...)
    -- body
end --日常活跃任务：奖章升级
function task_08(...)
    -- body
end --日常活跃任务：学习技能
function task_09(...)
    -- body
end --日常活跃任务：进行迁城
function task_10(...)
    -- body
end --日常活跃任务：使用计谋
function task_11(...)
    -- body
end --日常活跃任务：侦察玩家
function task_12(...)
    -- body
end --日常活跃任务：对玩家宣战
function task_13(...)
    -- body
end --日常活跃任务：袭击玩家
function task_14(...)
    -- body
end --日常活跃任务：征服玩家
function task_15(...)
    -- body
end --日常活跃任务：使用保险道具
function task_16(...)
    -- body
end --日常活跃任务：进行充值