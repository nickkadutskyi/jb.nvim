"use client";

import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Avatar, AvatarImage, AvatarFallback } from "@radix-ui/react-avatar";
import { Heart, MessageCircle } from "lucide-react";
import React from "react";

interface Props {
  name: string;
  content: string;
  likes: number;
  comments: number,
  isLiked: boolean;
  avatar: string;

  onLike(): void;

  onClick(): void;
}

export function TweetCard(props: Props) {
  const [isLiked, setIsLiked] = React.useState(props.isLiked);
  return (
    <Card className="border-gray-600 rounded-none" >
      <CardHeader>
        <CardTitle className="flex gap-2 items-center">
          <Avatar>
            <AvatarImage className="h-12" src={props.avatar} alt="@shadcn" />
            <AvatarFallback>Avatar</AvatarFallback>
          </ Avatar>
          <p className="text-md"> {props.name} </p>
        </CardTitle>
      </CardHeader >
      <CardContent className="flex flex-col">
        <div className="flex flex-col space-y-1.5">{props.content}</div>
        <div className="flex justify-start gap-x-4 mt-8">
          <div
            onClick={() => {
              setIsLiked((prevState) => !prevState);
              props.onLike();
            }}
            className="flex items-center gap-x-1 cursor-pointer"
          >
            <Heart size={12} fill={isLiked ? "#fff" : undefined} />
            {props.likes + (isLiked ? 1 : 0)}
          </div>
          <div className="flex items-center gap-x-1 cursor-pointer">
            <MessageCircle size={12} />
            {props.comments}
          </div>
        </div>
      </CardContent>
    </Card>
  )
}
