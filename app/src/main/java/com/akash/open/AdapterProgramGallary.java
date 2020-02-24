package com.akash.open;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;

import com.akash.open.ui.gallery.GalleryFragment;
import com.bumptech.glide.Glide;
import com.bumptech.glide.request.target.Target;
import com.google.firebase.storage.StorageReference;

import java.util.List;

public class AdapterProgramGallary  extends RecyclerView.Adapter<AdapterProgramGallary.ProgramViewHolder> {

    private List<StorageReference> resPath;



    public AdapterProgramGallary(List<StorageReference> resPath ){
        this.resPath = resPath;

    }


    @NonNull
    @Override
    public ProgramViewHolder onCreateViewHolder(@NonNull ViewGroup viewGroup, int i) {
        LayoutInflater inflater = LayoutInflater.from(viewGroup.getContext());
        View view = inflater.inflate(R.layout.recycler_view_gallery_item,viewGroup,false);

        return new AdapterProgramGallary.ProgramViewHolder(view);
    }

    @Override
    public void onBindViewHolder(@NonNull ProgramViewHolder programViewHolder, int i) {
        StorageReference path = resPath.get(i);


//        programViewHolder.textView.setText(name);

        Glide.with(programViewHolder.imageView.getContext())
                .load(path)
                .override(Target.SIZE_ORIGINAL,Target.SIZE_ORIGINAL)
                .into(programViewHolder.imageView);
        // if(imageStatusT == 0){programViewHolder.imgview.setImageResource(R.drawable.bulebutton); }
        // else if(imageStatusT == 1){programViewHolder.imgview.setImageResource(R.drawable.yellowbutton); }
        //else if(imageStatusT == 2){programViewHolder.imgview.setImageResource(R.drawable.greenbutton); }
    }

    @Override
    public int getItemCount() {
        return  resPath.size();
    }

    public class ProgramViewHolder extends RecyclerView.ViewHolder {

        ImageView imageView;


        public ProgramViewHolder(@NonNull View itemView) {
            super(itemView);

        imageView = (ImageView) itemView.findViewById(R.id.imageView);


            //  imgview = (ImageView) itemView.findViewById(R.id.statusImageView);
            //  textView = (TextView) itemView.findViewById(R.id.textView);
            //  textDataView = (TextView) itemView.findViewById(R.id.textView2);
            //   textAddressView = (TextView) itemView.findViewById(R.id.AddressTextView);
            //   textStatusView = (TextView) itemView.findViewById(R.id.statusView);

        }
    }
}
