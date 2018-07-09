function [] = getAppMotionRegionScores(videoFile, opticalflowdir,num)

folder = ['./Data/' videoFile '/frames/' videoFile 'Results']
img_dir = dir([folder '/Forward*'])
for i = 1:num-1;    
    
    sprintf('Flowfile from %d to %d frame',i,i+1)
    imname1 = sprintf('%04d',i) ;        
    imname2 = sprintf('%04d',i+1);  
  
    
    flowFile = [opticalflowdir imname1 '_to_' imname2 '.opticalflow.mat'];

    try
        load(flowFile,'vx','vy');
    catch
        im1 = frames(:,:,:,i);
        im2 = frames(:,:,:,i+1);
           
        flow = mex_LDOF(double(im1),double(im2));
        vx = flow(:,:,1);
        vy = flow(:,:,2);
        save(flowFile,'vx','vy');
    end
    %%%%%%%%%%%%%%%%%%%%
  
end
