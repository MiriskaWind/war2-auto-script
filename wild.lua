--[[
    本脚本适用于任意分辨率的设备。
--]]
init(0); --以当前应用 Home 键在右边初始化
require("TSLib") --调用触动函数库
require("lib") --调用关键函数库
require("lib")
bid = frontAppBid()
wild_times = 5000 --刷野次数
wild_city = 2 --刷野城市
t_delay = 500 --全局延迟变量
w,h = getScreenSize(); --获取设备分辨率
--以下为野地坐标，按顺序刷野
wild_coordinate = {} --创建刷野坐标数组
wild_x1,wild_y1 = 336,202 --左边第一个装甲师坐标
wild_x2,wild_y2 = 335,205 --右边第一个装甲师坐标
wild_x3,wild_y3 = 335,205 --右边第二装甲师坐标
wild_x4,wild_y4 = 335,207 --右边第二个装甲师坐标
wild_x5,wild_y5 = 336,202 --左边第三个装甲师坐标
wild_x6,wild_y6 = 336,201 --右边第三个装甲师坐标
table.insert(wild_coordinate,{wild_x1,wild_y1}) --添加第一个海平坐标
table.insert(wild_coordinate,{wild_x2,wild_y2}) --添加第二个海平坐标
table.insert(wild_coordinate,{wild_x3,wild_y3}) --添加第三个海平坐标
table.insert(wild_coordinate,{wild_x4,wild_y4}) --添加第四个海平坐标
table.insert(wild_coordinate,{wild_x5,wild_y5}) --添加第五个海平坐标
table.insert(wild_coordinate,{wild_x6,wild_y6}) --添加第六个海平坐标
keepalive() --保活判定
--获取城市坐标
city_collect()
--判断是否在刷野城市
repeat mSleep(100) until now_wid() == "地图区"
location_x,location_y = city_coordinate[wild_city][1],city_coordinate[wild_city][2]
location_wid,location_tab = widget.find({["id"]=bid..":id/city_location"})
nLog(location_tab["text"])
if location_tab["text"] == location_x..","..location_y then
    nLog("当前在在刷野城！")
else
    zuobiao(city_coordinate[wild_city][1],city_coordinate[wild_city][2]) --移动到目标
    ttap(h/2-1,w/2-1) --点击地图中心
    mSleep(500)
    text_click("进入")
    --等待进入军事区
    repeat mSleep(100) until now_wid() == "军事区"
end
--开始刷野
start_clock = getNetTime() --获取当前网络时间戳
for i = 0,wild_times,1 do --进入刷野循环
    zuobiao(wild_coordinate[i%#wild_coordinate+1][1],wild_coordinate[i%#wild_coordinate+1][2])
    --获取地图中心并点击
    ttap(w/2-1,h/2-1) --点击地图中心
    repeat mSleep(100) until now_wid() ~= "地图区"
    local wid_relocation = widget.find({["id"]=bid..":id/dialog_map_plain_bottom_button2",["text"]="迁城"})
    local wid_player =  widget.text("统帅",{["rule"]=1,["which"]=1})
    if wid_relocation == nil and wid_player == nil then
        local troops_set = {{18,33000},{21,1}}
        nLog("开始刷野")
        Shuaye("袭击",troops_set,"编制:")
        local times,t_wait = i+1,time_wait(city_coordinate[wild_city][1],city_coordinate[wild_city][2],wild_coordinate[i%#wild_coordinate+1][1],wild_coordinate[i%#wild_coordinate+1][2],arms[troops_set[1][1]][14],10,0)
        toast("第"..times.."次刷野，本次出征时间为"..t_wait.."秒！",100)
        nLog("第"..times.."次刷野，本次出征时间为"..t_wait.."秒！")
        mSleep((t_wait*2+1)*1000) --等待刷野左边海平刷野完成
    else
        button_click("exit_button") --关闭页面
    end
end
