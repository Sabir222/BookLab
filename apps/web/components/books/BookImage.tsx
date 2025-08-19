"use client";

import Image from "next/image";
import { useState } from "react";

interface BookImageProps {
  src: string;
  alt: string;
  width: number;
  height: number;
  className?: string;
}

export function BookImage({ src, alt, width, height, className }: BookImageProps) {
  const [imgSrc, setImgSrc] = useState(src);
  const [hasError, setHasError] = useState(false);

  const handleError = () => {
    if (!hasError) {
      setImgSrc("/placeholder-book-cover.jpg");
      setHasError(true);
    }
  };

  return (
    <Image
      src={imgSrc}
      alt={alt}
      width={width}
      height={height}
      className={className}
      onError={handleError}
    />
  );
}