require 'roxml'
require 'multi_xml'

MultiXml.parser = :nokogiri

xml = %Q{
<xml>
<ToUserName><![CDATA[toUser]]></ToUserName>
<FromUserName><![CDATA[fromUser]]></FromUserName>
<CreateTime>12345678</CreateTime>
<MsgType><![CDATA[music]]></MsgType>
<Music>
<Title><![CDATA[TITLE]]></Title>
<Description><![CDATA[DESCRIPTION]]></Description>
<MusicUrl><![CDATA[MUSIC_Url]]></MusicUrl>
<HQMusicUrl><![CDATA[HQ_MUSIC_Url]]></HQMusicUrl>
<ThumbMediaId><![CDATA[media_id]]></ThumbMediaId>
</Music>
</xml>
}

xml = %Q{<xml> <ToUserName><![CDATA[o2InVvyV_3voaWTy2Z1NZCDQ_DT8]]></ToUserName> <FromUserName><![CDATA[gh_6c18b947147f]]></FromUserName> <CreateTime>1499843449585</CreateTime> <MsgType><![CDATA[voice]]></MsgType> <Music> <Title><![CDATA[8930.mp3]]></Title> <Description><![CDATA[8930.mp3]]></Description> <MusicUrl><![CDATA[http://test.faqrobot.cn/upload/web/14519815792418039/20170712/50061499841697212.mp3]]></MusicUrl> <HQMusicUrl><![CDATA[http://test.faqrobot.cn/upload/web/14519815792418039/20170712/50061499841697212.mp3]]></HQMusicUrl> </Music> </xml>}


# xml = %Q{ <xml> <ToUserName><![CDATA[o2InVvyV_3voaWTy2Z1NZCDQ_DT8]]></ToUserName> <FromUserName><![CDATA[gh_6c18b947147f]]></FromUserName> <CreateTime>1499844098773</CreateTime> <MsgType><![CDATA[news]]></MsgType> <ArticleCount>1</ArticleCount> <Articles> <item> <Title><![CDATA[语音]]></Title> <Description><![CDATA[点击查看详情!]]></Description> <PicUrl><![CDATA[http://test.faqrobot.cn/upload/web/14519815792418039/20170711/20331499764610576.jpg]]></PicUrl> <Url><![CDATA[http://test.faqrobot.cn/upload/web/14519815792418039/20170629/58541498725483796.wav]]></Url> </item> </Articles> </xml> }


# xml = %Q{
# <xml>
# <ToUserName><![CDATA[toUser]]></ToUserName>
# <FromUserName><![CDATA[fromUser]]></FromUserName>
# <CreateTime>12345678</CreateTime>
# <MsgType><![CDATA[video]]></MsgType>
# <Video>
# <MediaId><![CDATA[media_id]]></MediaId>
# <Title><![CDATA[title]]></Title>
# <Description><![CDATA[description]]></Description>
# </Video>
# </xml>
# }

def factory(xml)
  hash = MultiXml.parse(xml)['xml']
  puts hash['MsgType']

  puts "="*40
  puts hash
end

factory(xml)
