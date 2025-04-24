import axios, { AxiosResponse, AxiosError, AxiosHeaders } from '@ohos/axios';
import { prompt } from '@kit.ArkUI';


const headers = new AxiosHeaders({
  'Content-Type': 'application/json',
});

// 定义请求数据类型
interface CreateTempTaskRequest {
  uid: number; // 用户ID（整数）
}

// 定义响应数据类型
interface CreateTempTaskResponse {
  taskid: string; // 任务ID（格式：uid_时间戳）
  message: string; // 状态信息
}

async function createTempTask(uid: number): Promise<string> {
  const url = 'http://120.55.76.15:3400/api/db/task/create_task/';
  const data: CreateTempTaskRequest = { uid };

  try {
    const response: AxiosResponse<CreateTempTaskResponse> = await axios.post(
      url,
      data,
      { headers: headers } // 请求头配置
    );

    if (response.status === 200) {
      console.log('临时任务创建成功', response.data.taskid);
      return response.data.taskid; // 返回任务ID
    } else {
      throw new Error(`服务器返回非200状态码: ${response.status}`);
    }
  } catch (error) {
    let errorMessage = '创建临时任务失败';
    if (axios.isAxiosError(error)) {
      const axiosError: AxiosError = error;
      console.error(`请求错误: ${axiosError.message}`, axiosError.response?.data);
    } else if (error instanceof Error) {
      errorMessage = error.message;
    }
    throw new Error(errorMessage);
  }
}

// 定义更新图像的请求数据类型
interface UpdateBadgeImagesRequest {
  taskid: string;
  ori_url: string; // 新增 image_url 字段用于更新
}

// 定义更新图像的响应数据类型
interface UpdateBadgeImagesResponse {
  message: string; // 状态信息
  mod_url:string
}

// 更新任务图像的函数
async function updateTaskImages(taskid: string, ori_url: string): Promise<string> {
  const url = 'http://120.55.76.15:3400/api/db/task/update_image/';
  const data: UpdateBadgeImagesRequest = {
    taskid,
    ori_url
  };

  try {
    const response: AxiosResponse<UpdateBadgeImagesResponse> = await axios.post(
      url,
      data,
      { headers: headers }
    );

    if (response.status === 200) {
      console.log('任务图像更新成功', response.data.message);
      return response.data.mod_url;
    } else {
      throw new Error(`服务器返回非200状态码: ${response.status}`);
    }
  } catch (error) {
    let errorMessage = '更新任务图像失败';
    if (axios.isAxiosError(error)) {
      const axiosError: AxiosError = error;
      if (axiosError.response) {
        // 服务器返回了响应，但状态码不是 200
        errorMessage = `请求失败，状态码: ${axiosError.response.status}，错误信息: ${JSON.stringify(axiosError.response.data)}`;
      } else if (axiosError.request) {
        // 请求已发送，但没有收到响应
        errorMessage = '请求已发送，但没有收到服务器响应';
      } else {
        // 请求设置时发生错误
        errorMessage = `请求设置错误: ${axiosError.message}`;
      }
    } else if (error instanceof Error) {
      errorMessage = error.message;
    }
    console.error(errorMessage);
    throw new Error(errorMessage);
  }
}

interface SrRequest {
  taskid: string; // 任务ID
}

interface SrResponse {
  message: string;
  resultUrl: string; // 超分辨率后的图片URL
}

async function sendSuperResolutionRequest(taskid: string): Promise<string> {
  prompt.showToast({message:"正在执行超分辨率操作，请稍后",duration:10000})
  const url = 'http://120.55.76.15:3900/api/dip/sr';
  const data: SrRequest = { taskid };
  console.log(taskid);
  try {
    const response: AxiosResponse<SrResponse> = await axios.post<SrResponse>(url, data, { headers });
    if (response.status === 200) {
      console.log('超分辨率处理成功', response.data.resultUrl);
      prompt.showToast({message:"超分辨率处理成功"})
      return response.data.resultUrl;
    } else {
      throw new Error(`服务器返回错误状态码: ${response.status}`);
    }
  } catch (error) {
    let errorMessage = '超分辨率请求失败';
    if (axios.isAxiosError(error)) {
      errorMessage = error.response?.data?.message || errorMessage;
    }
    throw new Error(errorMessage);
  }
}




export { createTempTask , updateTaskImages,sendSuperResolutionRequest}