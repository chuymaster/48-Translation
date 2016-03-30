//
//  Constants.swift
//  48+ Translation Mockup
//
//  Created by CHATCHAI LOKNIYOM on 3/23/16.
//  Copyright © 2016 CHATCHAI LOKNIYOM. All rights reserved.
//

import Foundation

/// Application constrants
struct Constants{
    
    // MARK: HTTP Methods
    
    struct HTTPMethod{
        static let GET = "GET"
        static let POST = "POST"
        static let PUT = "PUT"
        static let DELETE = "DELETE"
    }
    
    // MARK: General Constants
    
    struct General{
        static let DateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let GooglePlusFullPhotoSize = "s0"
        static let OrderKey = "order"
        static let PhotoExtension = ".jpg"
        static let ThumbnailInitial = "T"
        static let FullPhotoInitial = "F"
    }
    
    // MARK: Image name
    // https://icons8.com
    
    struct Image{
        static let StarBlank = "StarBlank"
        static let StarFilled = "StarFilled"
        static let Translation = "Translation"
    }
    
    // MARK: Static Database
    
    struct Database{
        static let MemberUserIdList: [(order:Int, id:String)] = [
            (1,"104773980789079999630"),
            (2,"106102390858541443310"),
            (3,"106166082359574012420"),
            (4,"118142366345814312525"),
            (5,"112054336332152179826"),
            (6,"103621242289574282721"),
            (7,"108854773205091274205"),
            (8,"111907069956262615426"),
            (9,"113849034080168289470"),
            (10,"102129137981135233143"),
            (11,"104375100134443203420"),
            (12,"101107068827865810697"),
            (13,"114958145471772079443"),
            (14,"108158383330906277526"),
            (15,"107241677527739013868"),
            (16,"103577079977140124149"),
            (17,"104003652269738791415"),
            (18,"100089260642973387997"),
            (19,"108592604171173727989"),
            (20,"102120909316124491120"),
            (21,"112196801092533679445"),
            (22,"107850647144188324652"),
            (23,"115743581016964883134"),
            (24,"112809008708989184267"),
            (25,"111363964900769496942"),
            (26,"112303747535405730870"),
            (27,"108233787438424471919"),
            (28,"113498563179644571221"),
            (29,"110723563001146503636"),
            (30,"102642528528615796356"),
            (31,"102808008463301583196"),
            (32,"115608229387461419797"),
            (33,"104185663412698594190"),
            (34,"107858117023519021548"),
            (35,"110200146300913549655"),
            (36,"106880477295979333654"),
            (37,"113611364612257749997"),
            (38,"115059632553757991807"),
            (39,"105047002579470450869"),
            (40,"108199783819141838282"),
            (41,"105493861434312425996"),
        ]
    }
    
    // MARK: Google+ API
    struct GooglePlusApi{
        static let ApiBaseURL = "https://www.googleapis.com/plus/v1/"
        
        struct ParameterKeys{
            static let Key = "key"
        }
        struct ParameterValues{
            static let Key = "AIzaSyBZ5ZR81H2K2YDlwVci3cfEScN7VOumKbA"
        }
        
        // MARK: People API
        // GET https://www.googleapis.com/plus/v1/people/108158383330906277526?key={YOUR_API_KEY}
        struct PeopleAPI{
            static let AppendPath = "people"
            
            struct ParameterKeys{
                static let UserId = "userId"
            }
            
            struct ResponseKeys{
                static let Id = "id"
                static let Name = "name"
                static let FamilyName = "familyName"
                static let GivenName = "givenName"
                static let Url = "url"
                static let Image = "image"
                static let TagLine = "tagline"
                static let AboutMe = "aboutMe"
            }
        }
        
        // MARK: People/Activities API
        // GET https://www.googleapis.com/plus/v1/people/108158383330906277526/activities/public?key={YOUR_API_KEY}
        struct ActivitiesAPI{
            static let AppendPath = "activities/public"
            
            struct ParameterKeys{
                static let Collection = "collection"
                static let MaxResults = "maxResults"
                static let PageToken = "pageToken"
            }
            
            struct ParameterValues{
                static let Collection = "public"
                static let MaxResults = "100"
            }
            
            struct ResponseKeys{
                // MARK: Activities Feed Property
                static let NextPageToken = "nextPageToken"
                static let Items = "items"
                
                // MARK: Activities Property
                static let Title = "title"
                static let Published = "published"
                static let Updated = "updated"
                static let Url = "url"
                static let Id = "id"
                static let Object = "object"
                static let Content = "content"
                static let Attachments = "attachments"
                static let ObjectType = "objectType"
                static let Type = "type"
                // MARK: Album attachment
                static let Thumbnails = "thumbnails"
                // MARK: Photo & Video attachment
                static let Image = "image"
                // MARK: Photo only attachment
                static let FullImage = "fullImage"
            }
            
            struct ResponseValues{
                // Attachment object type
                enum ObjectType: String{
                    case Album = "album"
                    case Photo = "photo"
                    case Video = "video"
                }
            }
        }
    }
}


/*
// Sample Response People
 
 {
 "kind": "plus#person",
 "etag": "\"4OZ_Kt6ujOh1jaML_U6RM6APqoE/JWpDF5IXpIcwCmcXZYymmQlEhm8\"",
 "urls": [
 {
 "value": "http://www.hkt48.jp/profile/tanaka_miku.html",
 "type": "other",
 "label": "HKT48"
 }
 ],
 "objectType": "person",
 "id": "108158383330906277526",
 "displayName": "田中美久",
 "name": {
 "familyName": "田中",
 "givenName": "美久"
 },
 "tagline": "HKT48/熊本県出身14歳！田中美久です♪\nよろしくお願いします(^O^)／\nみくりんもん\\(//∇//)\\",
 "url": "https://plus.google.com/108158383330906277526",
 "image": {
 "url": "https://lh3.googleusercontent.com/-dNvFgkld1WE/AAAAAAAAAAI/AAAAAAAAABE/zzg10zkwrvw/photo.jpg?sz=50",
 "isDefault": false
 },
 "isPlusUser": true,
 "circledByCount": 0,
 "verified": false,
 "cover": {
 "layout": "banner",
 "coverPhoto": {
 "url": "https://lh3.googleusercontent.com/kVY1OKRxzvq0FaQJImTMBXztfT1RNnVx6Vh3QfcwIlJ8aWKn7IevWLXQsI_r-_AgCEl8=s630-fcrop64=1,00000000ffffffff",
 "height": 705,
 "width": 940
 },
 "coverInfo": {
 "topImageOffset": 0,
 "leftImageOffset": 0
 }
 }
 }
 
 ///////////////////////////////////////

 
// Sample Response Activities
 {
 "kind": "plus#activityFeed",
 "etag": "\"4OZ_Kt6ujOh1jaML_U6RM6APqoE/Bb3gYlQTQJvZX76C6DbneuB8i8A\"",
 "nextPageToken": "Cg0Q3aT10LrWywIgACgBEhQIABCAnqTMutTLAhjonu_Rw6HLAhgCIBQo2dyP6_OIitE-",
 "title": "Google+ List of Activities for Collection PUBLIC",
 "updated": "2016-03-22T14:02:22.432Z",
 "items": [
 {
 "kind": "plus#activity",
 "etag": "\"4OZ_Kt6ujOh1jaML_U6RM6APqoE/0n3jhSxl875DTs4G7Nma3GLd-vs\"",
 "title": "こんばんみクリイヴ(=´∀｀)人(´∀｀=)\n\n今日は、学校行って少しだけお仕事をしました。\n\nいつもは、お仕事終わったら真っ直ぐ帰るんですが、今日はおかぱんさんの卒業公演だったので、お母さんとマネージャー...",
 "published": "2016-03-22T14:02:22.432Z",
 "updated": "2016-03-22T14:02:22.432Z",
 "id": "z13jgxhiouiggrbrx04cg52wizjmfpyiqgc",
 "url": "https://plus.google.com/108158383330906277526/posts/jMje8Pg7gVj",
 "actor": {
 "id": "108158383330906277526",
 "displayName": "田中美久",
 "url": "https://plus.google.com/108158383330906277526",
 "image": {
 "url": "https://lh3.googleusercontent.com/-dNvFgkld1WE/AAAAAAAAAAI/AAAAAAAAABE/zzg10zkwrvw/photo.jpg?sz=50"
 },
 "verification": {
 "adHocVerified": "UNKNOWN_VERIFICATION_STATUS"
 }
 },
 "verb": "post",
 "object": {
 "objectType": "note",
 "actor": {
 "verification": {
 "adHocVerified": "UNKNOWN_VERIFICATION_STATUS"
 }
 },
 "content": "こんばんみクリイヴ(=´∀｀)人(´∀｀=)<br /><br />今日は、学校行って少しだけお仕事をしました。<br /><br />いつもは、お仕事終わったら真っ直ぐ帰るんですが、今日はおかぱんさんの卒業公演だったので、お母さんとマネージャーさんに許可をもらって見させて頂きました^_^<br /><br />お仕事がなかったら、絶対おかぱんさんの卒業公演を見たい！とずっと思っていたので、叶って嬉しかったです。<br /><br />最後のおかぱんさんをずっと目に焼き付けてきました。。。<br /><br />そこには、輝いてるおかぱんさんがいました。。<br /><br />公演を見ていくたびに、おかぱんさんとの思い出がこみあがってきて…<br />青森コンサートで二人でお散歩したり、ホテルでお互い違う部屋同士なのにわざわざ一緒の部屋に集まって話しをしたり一緒に寝たり、握手会や公演の時におかぱんさんにメイクしてもらったり、一緒にご飯食べに行ったりおでかけに行ったり…書き足りないくらいです。。<br /><br />おかぱんさんが前に私に話してくれたこと。<br />今でもはっきり覚えています。<br /><br />今日打ち上げを集まれるメンバーだけでやった時に、早くお泊まりに来てね！とか連絡ちゃんとしてよ！とか嬉しい変わらないおかぱんさんがそこにいて…<br /><br />私は、おかぱんさんから私に似てる部分があるから共感出来ることもあると思う。だから悩みを相談してねと言われました。私の支えでもあり温かい存在だったおかぱんさん（ ;  ; ）<br />お仕事が早く終わってたので、公演まで時間があり、いもむちゅのメンバーさんとずっと遊んだり、おかぱんさんと話したりして公演始まるのを待っていました(￣^￣)ゞ<br /><br />おかぱんさんが手作りのケーキを作ってきてくれて…。<br /><br />もう、明日からおかぱんさんがいないHKTなんだな…(´･_･`)と淋しくなりました。。（ ;  ; ）<br /><br />でも、今日のおかぱんさんを見て輝いていて、、もうおかぱんさんは次のステップに進んでいるんだな、私だけ淋しいとかずっと考えてたら駄目だな…と考えさせられました。<br /><br />今日、公演を見学出来た事に感謝します。<br /><br />卒業といえば、もうすぐたかみなさんの卒業コンサート！！<br /><br />新しく入って来るメンバーがいれば卒業するメンバーもいる。。<br /><br />色々な事がある48グループですが、皆さんの変わらぬ応援を期待しています。<br /><br />それでは<br /><br />みくりんもん(￣(工)￣)\ufeff",
 "url": "https://plus.google.com/108158383330906277526/posts/jMje8Pg7gVj",
 "replies": {
 "totalItems": 196,
 "selfLink": "https://content.googleapis.com/plus/v1/activities/z13jgxhiouiggrbrx04cg52wizjmfpyiqgc/comments"
 },
 "plusoners": {
 "totalItems": 2365,
 "selfLink": "https://content.googleapis.com/plus/v1/activities/z13jgxhiouiggrbrx04cg52wizjmfpyiqgc/people/plusoners"
 },
 "resharers": {
 "totalItems": 22,
 "selfLink": "https://content.googleapis.com/plus/v1/activities/z13jgxhiouiggrbrx04cg52wizjmfpyiqgc/people/resharers"
 },
 "attachments": [
 {
 "objectType": "album",
 "displayName": "2016/03/22",
 "id": "108158383330906277526.6264876992793522273",
 "url": "https://plus.google.com/photos/108158383330906277526/albums/6264876992793522273?authkey=CJeBmrGOlfGuMw",
 "thumbnails": [
 {
 "url": "https://plus.google.com/photos/108158383330906277526/albums/6264876992793522273/6264876993955361458",
 "description": "",
 "image": {
 "url": "https://lh3.googleusercontent.com/-cgvdZxKadJ0/VvFQbuo58rI/AAAAAAAAJVU/KZ_2jBhjd_4/w253-h253-p/IMG_4132.JPG",
 "type": "image/jpeg",
 "height": 253,
 "width": 253
 }
 },
 {
 "url": "https://plus.google.com/photos/108158383330906277526/albums/6264876992793522273/6264876991576714946",
 "description": "",
 "image": {
 "url": "https://lh3.googleusercontent.com/-WvJsO9yvb4E/VvFQblxyrsI/AAAAAAAAJVU/x87qxrPw3oM/w253-h253-p/IMG_4130.JPG",
 "type": "image/jpeg",
 "height": 253,
 "width": 253
 }
 }
 ]
 }
 ]
 },
 "provider": {
 "title": "Google+"
 },
 "access": {
 "kind": "plus#acl",
 "description": "Public",
 "items": [
 {
 "type": "public"
 }
 ]
 }
 },
 */