import axios, { AxiosError, AxiosHeaders, AxiosResponse } from '@ohos/axios';

interface lyrics_information {
  lid: number;
  title: string;
  cv: string;
  lyric_url: string;
}

const headers = new AxiosHeaders({
  'Content-Type': 'application/json',
});

interface Data {
  keyword: string;
}

let lyrics: lyrics_information[] = [];

async function search_lyrics(query_name: string) {
  console.log("搜索的名字是", query_name);
  const getURL = "http://120.55.76.15:3400/api/db/lyrics/search";
  const data: Data = {
    keyword: query_name
  };

  try {
    const response: AxiosResponse<lyrics_information[]> = await axios.post(
      getURL,
      data,
      { headers: headers }
    );

    // 直接将返回的数组赋值给 lyrics
    lyrics = response.data;
    return lyrics;
  } catch (error) {
    if (axios.isAxiosError(error)) {
      const axiosError: AxiosError = error;
      console.error(`Response err: Code is ${axiosError.response?.status}, message is ${axiosError.message}`);
      AlertDialog.show({
        title: "搜索失败",
        message: "发生错误"
      });
    } else {
      console.error(`An unexpected error occurred: ${error}`);
    }
    return lyrics;
  }
}

interface bgms_information {
  bgmid: number;
  title: string;
  author: string;
  bgm_url: string;
}
let bgms: bgms_information[] = [];

async function search_bgms(query_name: string) {
  console.log("搜索的名字是", query_name);
  const getURL = "http://120.55.76.15:3400/api/db/bgms/search";
  const data: Data = {
    keyword: query_name
  };

  try {
    const response: AxiosResponse<bgms_information[]> = await axios.post(
      getURL,
      data,
      { headers: headers }
    );

    // 直接将返回的数组赋值给 lyrics
    bgms = response.data;
    return bgms;
  } catch (error) {
    if (axios.isAxiosError(error)) {
      const axiosError: AxiosError = error;
      console.error(`Response err: Code is ${axiosError.response?.status}, message is ${axiosError.message}`);
      AlertDialog.show({
        title: "搜索失败",
        message: "发生错误"
      });
    } else {
      console.error(`An unexpected error occurred: ${error}`);
    }
    return bgms;
  }
}


interface Badge{
  bid: number
  specification:number
  title:string
  img_url:string
  flash_bottom:string
  fb_name:string
  film_cover:string
  fc_name:string
  lyric_url:string
  lyric_name:string
  BGM_url:string
  BGM_name:string
  video_url:string
  update_time:string
}

interface Data_uid{
  uid:string
}

let badges: Badge[] = [];

async function search_user_Badges(query_uid: string) {
  console.log("搜索的名字是", query_uid);
  const getURL = "http://120.55.76.15:3400/api/db/badges/user_badge_search";
  const data: Data_uid = {
    uid: query_uid
  };

  try {
    const response: AxiosResponse<Badge[]> = await axios.post(
      getURL,
      data,
      { headers: headers }
    );

    // 直接将返回的数组赋值给 lyrics
    badges = response.data;
    return badges;
  } catch (error) {
    if (axios.isAxiosError(error)) {
      const axiosError: AxiosError = error;
      console.error(`Response err: Code is ${axiosError.response?.status}, message is ${axiosError.message}`);
      AlertDialog.show({
        title: "搜索失败",
        message: "发生错误"
      });
    } else {
      console.error(`An unexpected error occurred: ${error}`);
    }
    return badges;
  }
}

export { search_lyrics, search_bgms,search_user_Badges };